variable "application_gateways" {
  type = map(object({
    name                           = string
    resource_group_key             = optional(string, null)
    subnet_key                     = optional(string, null)
    public_ip_key                  = optional(string, null)
    managed_identity_key           = optional(string, null)
    sku_name                       = string
    sku_tier                       = string
    capacity                       = optional(number, 2)
    enable_autoscale               = optional(bool, false)
    autoscale_min_capacity         = optional(number, 1)
    autoscale_max_capacity         = optional(number, 10)

    public_ip_address_id           = string
    frontend_ip_configuration_name = string

    frontend_ports = map(object({
      name = string
      port = number
    }))

    backend_address_pools = map(object({
      name         = string
      fqdns        = optional(list(string), [])
      ip_addresses = optional(list(string), [])
    }))

    backend_http_settings = map(object({
      name                                = string
      cookie_based_affinity               = string
      port                                = number
      protocol                            = string
      request_timeout                     = number
      probe_name                          = optional(string, null)
      host_name                           = optional(string, null)
      pick_host_name_from_backend_address = optional(bool, false)
    }))

    http_listeners = map(object({
      name                           = string
      frontend_port_name             = string
      protocol                       = string
      host_name                      = optional(string, null)
      require_sni                    = optional(bool, false)
      ssl_certificate_name           = optional(string, null)
      firewall_policy_id             = optional(string, null)
    }))

    request_routing_rules = map(object({
      name                        = string
      rule_type                   = string
      priority                    = number
      http_listener_name          = string
      backend_address_pool_name   = optional(string, null)
      backend_http_settings_name  = optional(string, null)
      redirect_configuration_name = optional(string, null)
      rewrite_rule_set_name       = optional(string, null)
      url_path_map_name           = optional(string, null)
    }))

    probes = optional(map(object({
      name                                      = string
      protocol                                  = string
      path                                      = string
      interval                                  = number
      timeout                                   = number
      unhealthy_threshold                       = number
      pick_host_name_from_backend_http_settings = bool
      host                                      = optional(string, null)

      match = optional(object({
        status_code = string
      }), null)
    })), {})

    ssl_certificates = optional(map(object({
      name                = string
      key_vault_secret_id = string
    })), {})

    url_path_maps = optional(map(object({
      name                               = string
      default_backend_address_pool_name  = string
      default_backend_http_settings_name = string

      path_rules = map(object({
        name                       = string
        paths                      = list(string)
        backend_address_pool_name  = string
        backend_http_settings_name = string
      }))
    })), {})

    redirect_configurations = optional(map(object({
      name                 = string
      redirect_type        = string
      target_listener_name = optional(string, null)
      target_url           = optional(string, null)
      include_path         = optional(bool, true)
      include_query_string = optional(bool, true)
    })), {})

    waf_enabled          = optional(bool, true)
    waf_firewall_mode    = optional(string, "Prevention")
    waf_rule_set_type    = optional(string, "OWASP")
    waf_rule_set_version = optional(string, "3.2")

    enable_http2 = optional(bool, true)
  }))

  default = {
    primary = {
      name                           = "agw-rewn-prod"
      sku_name                       = "WAF_v2"
      sku_tier                       = "WAF_v2"

      capacity                       = 2
      enable_autoscale               = true
      autoscale_min_capacity         = 1
      autoscale_max_capacity         = 10

      public_ip_address_id           = ""
      frontend_ip_configuration_name = "appGwPublicFrontendIpIPv4"

      frontend_ports = {
        http = {
          name = "port-80"
          port = 80
        }

        https = {
          name = "port-443"
          port = 443
        }
      }

      backend_address_pools        = {}
      backend_http_settings       = {}
      http_listeners              = {}
      request_routing_rules       = {}
      probes                      = {}
      ssl_certificates            = {}
      url_path_maps               = {}
      redirect_configurations     = {}

      waf_enabled          = true
      waf_firewall_mode    = "Prevention"
      waf_rule_set_type    = "OWASP"
      waf_rule_set_version = "3.2"

      enable_http2 = true
    }
  }
}