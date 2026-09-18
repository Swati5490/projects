resource "azurerm_application_gateway" "main" {
  for_each = var.application_gateways

  name                = each.value.name
  location            = var.location
  resource_group_name = each.value.resource_group_name

  sku {
    name     = each.value.sku_name
    tier     = each.value.sku_tier
    capacity = each.value.enable_autoscale ? null : each.value.capacity
  }

  dynamic "autoscale_configuration" {
    for_each = each.value.enable_autoscale ? [1] : []

    content {
      min_capacity = each.value.autoscale_min_capacity
      max_capacity = each.value.autoscale_max_capacity
    }
  }

  dynamic "identity" {
  for_each = try(each.value.managed_identity_id, null) != null ? [1] : []

  content {
    type         = "UserAssigned"
    identity_ids = [each.value.managed_identity_id]
  }
}

  gateway_ip_configuration {
  name      = "${each.key}-gateway-ip"
  subnet_id = each.value.subnet_id
}

  dynamic "frontend_port" {
    for_each = each.value.frontend_ports

    content {
      name = frontend_port.value.name
      port = frontend_port.value.port
    }
  }

  frontend_ip_configuration {
    name                 = each.value.frontend_ip_configuration_name
    public_ip_address_id = each.value.public_ip_address_id
  }

  dynamic "backend_address_pool" {
    for_each = each.value.backend_address_pools

    content {
      name         = backend_address_pool.value.name
      fqdns        = backend_address_pool.value.fqdns
      ip_addresses = backend_address_pool.value.ip_addresses
    }
  }

  dynamic "backend_http_settings" {
    for_each = each.value.backend_http_settings

    content {
      name                                = backend_http_settings.value.name
      cookie_based_affinity               = backend_http_settings.value.cookie_based_affinity
      port                                = backend_http_settings.value.port
      protocol                            = backend_http_settings.value.protocol
      request_timeout                     = backend_http_settings.value.request_timeout
      probe_name                          = backend_http_settings.value.probe_name
      host_name                           = backend_http_settings.value.host_name
      pick_host_name_from_backend_address = backend_http_settings.value.pick_host_name_from_backend_address
    }
  }

  dynamic "http_listener" {
    for_each = each.value.http_listeners

    content {
      name                           = http_listener.value.name
      frontend_ip_configuration_name = each.value.frontend_ip_configuration_name
      frontend_port_name             = http_listener.value.frontend_port_name
      protocol                       = http_listener.value.protocol
      host_name                      = http_listener.value.host_name
      require_sni                    = http_listener.value.require_sni
      ssl_certificate_name           = http_listener.value.ssl_certificate_name
      firewall_policy_id             = http_listener.value.firewall_policy_id
    }
  }

  dynamic "request_routing_rule" {
    for_each = each.value.request_routing_rules

    content {
      name                        = request_routing_rule.value.name
      rule_type                   = request_routing_rule.value.rule_type
      priority                    = request_routing_rule.value.priority
      http_listener_name          = request_routing_rule.value.http_listener_name
      backend_address_pool_name   = request_routing_rule.value.backend_address_pool_name
      backend_http_settings_name  = request_routing_rule.value.backend_http_settings_name
      redirect_configuration_name = request_routing_rule.value.redirect_configuration_name
      rewrite_rule_set_name       = request_routing_rule.value.rewrite_rule_set_name
      url_path_map_name           = request_routing_rule.value.url_path_map_name
    }
  }

  dynamic "probe" {
    for_each = each.value.probes

    content {
      name                                      = probe.value.name
      protocol                                  = probe.value.protocol
      path                                      = probe.value.path
      interval                                  = probe.value.interval
      timeout                                   = probe.value.timeout
      unhealthy_threshold                       = probe.value.unhealthy_threshold
      pick_host_name_from_backend_http_settings = probe.value.pick_host_name_from_backend_http_settings
      host                                      = probe.value.host

      dynamic "match" {
        for_each = probe.value.match != null ? [probe.value.match] : []

        content {
          status_code = probe.value.match.status_code
        }
      }
    }
  }

  dynamic "ssl_certificate" {
    for_each = each.value.ssl_certificates

    content {
      name                = ssl_certificate.value.name
      key_vault_secret_id = ssl_certificate.value.key_vault_secret_id
    }
  }

  dynamic "url_path_map" {
    for_each = each.value.url_path_maps

    content {
      name                               = url_path_map.value.name
      default_backend_address_pool_name  = url_path_map.value.default_backend_address_pool_name
      default_backend_http_settings_name = url_path_map.value.default_backend_http_settings_name

      dynamic "path_rule" {
        for_each = url_path_map.value.path_rules

        content {
          name                       = path_rule.value.name
          paths                      = path_rule.value.paths
          backend_address_pool_name  = path_rule.value.backend_address_pool_name
          backend_http_settings_name = path_rule.value.backend_http_settings_name
        }
      }
    }
  }

  dynamic "redirect_configuration" {
    for_each = each.value.redirect_configurations

    content {
      name                 = redirect_configuration.value.name
      redirect_type        = redirect_configuration.value.redirect_type
      target_listener_name = redirect_configuration.value.target_listener_name
      target_url           = redirect_configuration.value.target_url
      include_path         = redirect_configuration.value.include_path
      include_query_string = redirect_configuration.value.include_query_string
    }
  }

  firewall_policy_id = each.value.firewall_policy_id

  enable_http2 = each.value.enable_http2

  tags = merge(
    var.tags,
    {
      Environment = var.environment
      Project     = var.project_name
    }
  )

  lifecycle {
    ignore_changes = [tags]
  }
}