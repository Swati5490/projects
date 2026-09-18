# Front Door Module

# Front Door CDN
resource "azurerm_cdn_frontdoor_profile" "main" {
  count = var.front_door_name != null ? 1 : 0

  name                = var.front_door_name
  resource_group_name = var.resource_group_name
  sku_name            = var.sku_name

  tags = merge(
    var.tags,
    {
      Environment = var.environment
    }
  )
}

# Backend Pools
resource "azurerm_cdn_frontdoor_origin_group" "main" {
  for_each = var.backend_pools

  name                     = each.value.name
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.main[0].id
  session_affinity_enabled = each.value.session_affinity == "Enabled" ? true : false

  health_probe {
    interval_in_seconds = 100
    path                = "/"
    protocol            = "Https"
    request_type        = "HEAD"
  }

  load_balancing {
    additional_latency_in_milliseconds = 0
    sample_size                        = 4
    successful_samples_required        = 3
  }
}

# Backend Hosts
resource "azurerm_cdn_frontdoor_origin" "main" {
  for_each = merge([
    for pool_name, pool_config in var.backend_pools : {
      for idx, backend in pool_config.backends :
      "${pool_name}-${idx}" => {
        pool_name = pool_config.name
        pool_id   = azurerm_cdn_frontdoor_origin_group.main[pool_name].id
        address   = backend.address
        port      = backend.port
      }
    }
  ]...)

  name                           = each.key
  cdn_frontdoor_origin_group_id  = each.value.pool_id
  enabled                        = true
  http_port                      = 80
  https_port                     = each.value.port
  origin_host_header             = each.value.address
  host_name                      = each.value.address
  certificate_name_check_enabled = true
  priority                       = 1
  weight                         = 1000
}

# Frontend Endpoints
resource "azurerm_cdn_frontdoor_endpoint" "main" {
  for_each = var.frontend_endpoints

  name                     = replace(each.value.host_name, ".", "-")
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.main[0].id
}

# Custom Domains
resource "azurerm_cdn_frontdoor_custom_domain" "main" {
  for_each = var.frontend_endpoints

  name                     = "${replace(each.value.host_name, ".", "-")}-domain"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.main[0].id
  host_name                = each.value.host_name

  tls {
    certificate_type = "ManagedCertificate"
  }
}

# Routing Rules
resource "azurerm_cdn_frontdoor_route" "main" {
  for_each = var.routing_rules

  name                          = each.key
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.main[each.value.frontend_endpoint_name].id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.main[each.value.backend_pool_name].id
  cdn_frontdoor_origin_ids = [
    azurerm_cdn_frontdoor_origin.main["${each.value.backend_pool_name}-0"].id
  ]
  supported_protocols    = each.value.accepted_protocols
  patterns_to_match      = [each.value.pattern_to_match]
  forwarding_protocol    = "HttpsOnly"
  link_to_default_domain = false
  enabled                = true

  cache {
    query_string_caching_behavior = "IgnoreQueryString"
  }
}

# WAF Policy (Optional)
resource "azurerm_cdn_frontdoor_firewall_policy" "main" {
  count = var.enable_waf ? 1 : 0

  name                              = "waf${replace(var.front_door_name, "-", "")}"
  resource_group_name               = var.resource_group_name
  sku_name                          = var.sku_name
  enabled                           = true
  mode                              = var.waf_policy_mode
  redirect_url                      = null
  custom_block_response_status_code = 403
  custom_block_response_body        = base64encode("Access denied")

  managed_rule {
    type    = "DefaultRuleSet"
    version = "1.0"
    action  = "Block"
  }

  managed_rule {
    type    = "BotProtection"
    version = "1.0"
    action  = "Log"
  }
}
