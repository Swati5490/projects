# Application Gateway Module

# Public IP for AppGW
resource "azurerm_public_ip" "appgw" {
  count = var.public_ip_name != null ? 1 : 0

  name                = var.public_ip_name
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = length(var.zones) > 0 ? var.zones : null

  tags = merge(
    var.tags,
    {
      Environment = var.environment
    }
  )
}

# Application Gateway
resource "azurerm_application_gateway" "main" {
  count = var.appgw_name != null ? 1 : 0

  name                = var.appgw_name
  location            = var.location
  resource_group_name = var.resource_group_name
  zones               = length(var.zones) > 0 ? var.zones : null

  sku {
    name     = var.sku_name
    tier     = var.sku_tier
    capacity = var.capacity
  }

  gateway_ip_configuration {
    name      = "gateway-ip-config"
    subnet_id = var.subnet_id
  }

  dynamic "frontend_port" {
    for_each = var.http_listeners
    content {
      name = "${frontend_port.key}-port"
      port = frontend_port.value.port
    }
  }

  frontend_ip_configuration {
    name                 = "appgw-frontend-ip"
    public_ip_address_id = var.public_ip_name != null ? azurerm_public_ip.appgw[0].id : null
  }

  dynamic "backend_address_pool" {
    for_each = var.backend_address_pools
    content {
      name  = backend_address_pool.value.name
      fqdns = backend_address_pool.value.fqdns
      ip_addresses = backend_address_pool.value.ips
    }
  }

  dynamic "backend_http_settings" {
    for_each = var.http_settings
    content {
      name                  = backend_http_settings.key
      cookie_based_affinity = backend_http_settings.value.cookie_based_affinity
      port                  = backend_http_settings.value.port
      protocol              = backend_http_settings.value.protocol
      request_timeout       = backend_http_settings.value.request_timeout
    }
  }

  dynamic "http_listener" {
    for_each = var.http_listeners
    content {
      name                           = http_listener.key
      frontend_ip_configuration_name = "appgw-frontend-ip"
      frontend_port_name             = "${http_listener.key}-port"
      protocol                       = http_listener.value.protocol
      host_name                      = http_listener.value.host_name
      require_sni                    = http_listener.value.require_sni
    }
  }

  dynamic "request_routing_rule" {
    for_each = var.request_routing_rules
    content {
      name                       = request_routing_rule.key
      rule_type                  = request_routing_rule.value.rule_type
      http_listener_name         = request_routing_rule.value.http_listener_name
      backend_address_pool_name  = request_routing_rule.value.backend_pool_name
      backend_http_settings_name = request_routing_rule.value.http_settings_name
      redirect_configuration_name = request_routing_rule.value.redirect_config_name
      priority                   = index(keys(var.request_routing_rules), request_routing_rule.key) + 100
    }
  }

  dynamic "waf_configuration" {
    for_each = var.enable_waf ? [1] : []
    content {
      enabled          = var.enable_waf
      firewall_mode    = var.waf_mode
      rule_set_type    = "OWASP"
      rule_set_version = "3.1"
    }
  }

  tags = merge(
    var.tags,
    {
      Environment = var.environment
    }
  )

  lifecycle {
    ignore_changes = [tags["CreatedDate"]]
  }
}
