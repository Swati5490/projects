application_gateways = {
  primary = {

    # ==========================================================================
    # RESOURCE REFERENCES
    # ==========================================================================

    resource_group_key = "rg_network"
    subnet_key         = "snet_appgw"
    public_ip_key      = "pip_appgw_prod"

    # ==========================================================================
    # APPLICATION GATEWAY
    # ==========================================================================

    name     = "agw-rewn-prod"
    sku_name = "WAF_v2"
    sku_tier = "WAF_v2"

    # Autoscaling
    capacity               = 2
    enable_autoscale       = true
    autoscale_min_capacity = 1
    autoscale_max_capacity = 10

    # This value is resolved dynamically in main.tf
    public_ip_address_id = null

    frontend_ip_configuration_name = "appGwPublicFrontendIpIPv4"

    # ==========================================================================
    # FRONTEND PORTS
    # ==========================================================================

    frontend_ports = {
      http = {
        name = "port-80"
        port = 80
      }
    }

    # ==========================================================================
    # BACKEND ADDRESS POOLS
    #
    # Replace the placeholder FQDNs once Container Apps are deployed.
    # ==========================================================================

    backend_address_pools = {

      myiflip = {
        name         = "myiflip-be"
        fqdns        = []
        ip_addresses = []
      }

      openrei = {
        name         = "openrei-be"
        fqdns        = []
        ip_addresses = []
      }

      phone_api = {
        name         = "phone-api-be"
        fqdns        = []
        ip_addresses = []
      }

      phpmya = {
        name         = "phpmya-be"
        fqdns        = []
        ip_addresses = []
      }

      pipeline_ui = {
        name         = "pipeline-ui-be"
        fqdns        = []
        ip_addresses = []
      }

      private_lender_marketplace = {
        name         = "private-lender-marketplace-be"
        fqdns        = []
        ip_addresses = []
      }

      private_lender_marketplace_api = {
        name         = "private-lender-marketplace-api-be"
        fqdns        = []
        ip_addresses = []
      }

      ressentials = {
        name         = "ressentials-be"
        fqdns        = []
        ip_addresses = []
      }

      rest = {
        name         = "rest-be"
        fqdns        = []
        ip_addresses = []
      }

      rewn_admin = {
        name         = "rewn-admin-be"
        fqdns        = []
        ip_addresses = []
      }

      rewn_chat = {
        name         = "rewn-chat-be"
        fqdns        = []
        ip_addresses = []
      }

      rewn_dialer = {
        name         = "rewn-dialer-be"
        fqdns        = []
        ip_addresses = []
      }

      rewn_fastapi = {
        name         = "rewn-fastapi-be"
        fqdns        = []
        ip_addresses = []
      }

      comps = {
        name         = "comps-be"
        fqdns        = []
        ip_addresses = []
      }
    }

    # ==========================================================================
    # BACKEND HTTP SETTINGS
    # ==========================================================================

    backend_http_settings = {

      myiflip = {
        name                                = "myiflip-http-settings"
        cookie_based_affinity               = "Disabled"
        port                                = 80
        protocol                            = "Http"
        request_timeout                     = 60
        probe_name                          = "myiflip-health"
        host_name                           = null
        pick_host_name_from_backend_address = true
      }

      openrei = {
        name                                = "openrei-http-settings"
        cookie_based_affinity               = "Disabled"
        port                                = 80
        protocol                            = "Http"
        request_timeout                     = 60
        probe_name                          = "openrei-health"
        host_name                           = null
        pick_host_name_from_backend_address = true
      }

      phone_api = {
        name                                = "phone-api-http-settings"
        cookie_based_affinity               = "Disabled"
        port                                = 80
        protocol                            = "Http"
        request_timeout                     = 60
        probe_name                          = "phone-api-health"
        host_name                           = null
        pick_host_name_from_backend_address = true
      }

      phpmya = {
        name                                = "phpmya-http-settings"
        cookie_based_affinity               = "Disabled"
        port                                = 80
        protocol                            = "Http"
        request_timeout                     = 60
        probe_name                          = null
        host_name                           = null
        pick_host_name_from_backend_address = true
      }

      pipeline_ui = {
        name                                = "pipeline-ui-http-settings"
        cookie_based_affinity               = "Disabled"
        port                                = 80
        protocol                            = "Http"
        request_timeout                     = 60
        probe_name                          = null
        host_name                           = null
        pick_host_name_from_backend_address = true
      }

      private_lender_marketplace = {
        name                                = "plm-http-settings"
        cookie_based_affinity               = "Disabled"
        port                                = 80
        protocol                            = "Http"
        request_timeout                     = 60
        probe_name                          = null
        host_name                           = null
        pick_host_name_from_backend_address = true
      }

      private_lender_marketplace_api = {
        name                                = "plm-api-http-settings"
        cookie_based_affinity               = "Disabled"
        port                                = 80
        protocol                            = "Http"
        request_timeout                     = 60
        probe_name                          = null
        host_name                           = null
        pick_host_name_from_backend_address = true
      }

      ressentials = {
        name                                = "ressentials-http-settings"
        cookie_based_affinity               = "Disabled"
        port                                = 80
        protocol                            = "Http"
        request_timeout                     = 60
        probe_name                          = null
        host_name                           = null
        pick_host_name_from_backend_address = true
      }

      rest = {
        name                                = "rest-http-settings"
        cookie_based_affinity               = "Disabled"
        port                                = 80
        protocol                            = "Http"
        request_timeout                     = 60
        probe_name                          = null
        host_name                           = null
        pick_host_name_from_backend_address = true
      }

      rewn_admin = {
        name                                = "rewn-admin-http-settings"
        cookie_based_affinity               = "Disabled"
        port                                = 80
        protocol                            = "Http"
        request_timeout                     = 60
        probe_name                          = null
        host_name                           = null
        pick_host_name_from_backend_address = true
      }

      rewn_chat = {
        name                                = "rewn-chat-http-settings"
        cookie_based_affinity               = "Disabled"
        port                                = 80
        protocol                            = "Http"
        request_timeout                     = 60
        probe_name                          = null
        host_name                           = null
        pick_host_name_from_backend_address = true
      }

      rewn_dialer = {
        name                                = "rewn-dialer-http-settings"
        cookie_based_affinity               = "Disabled"
        port                                = 80
        protocol                            = "Http"
        request_timeout                     = 60
        probe_name                          = null
        host_name                           = null
        pick_host_name_from_backend_address = true
      }

      rewn_fastapi = {
        name                                = "rewn-fastapi-http-settings"
        cookie_based_affinity               = "Disabled"
        port                                = 8000
        protocol                            = "Http"
        request_timeout                     = 60
        probe_name                          = "rewn-fastapi-health"
        host_name                           = null
        pick_host_name_from_backend_address = true
      }

      comps = {
        name                                = "comps-http-settings"
        cookie_based_affinity               = "Disabled"
        port                                = 80
        protocol                            = "Http"
        request_timeout                     = 60
        probe_name                          = "comps-health"
        host_name                           = null
        pick_host_name_from_backend_address = true
      }
    }

    # ==========================================================================
    # HEALTH PROBES
    # ==========================================================================

    probes = {

      myiflip = {
        name                                      = "myiflip-health"
        protocol                                  = "Http"
        path                                      = "/health"
        interval                                  = 30
        timeout                                   = 30
        unhealthy_threshold                       = 3
        pick_host_name_from_backend_http_settings = true
        host                                      = null
        match                                     = null
      }

      openrei = {
        name                                      = "openrei-health"
        protocol                                  = "Http"
        path                                      = "/health"
        interval                                  = 30
        timeout                                   = 30
        unhealthy_threshold                       = 3
        pick_host_name_from_backend_http_settings = true
        host                                      = null
        match                                     = null
      }

      phone_api = {
        name                                      = "phone-api-health"
        protocol                                  = "Http"
        path                                      = "/health"
        interval                                  = 30
        timeout                                   = 30
        unhealthy_threshold                       = 3
        pick_host_name_from_backend_http_settings = true
        host                                      = null
        match                                     = null
      }

      rewn_fastapi = {
        name                                      = "rewn-fastapi-health"
        protocol                                  = "Http"
        path                                      = "/health"
        interval                                  = 30
        timeout                                   = 30
        unhealthy_threshold                       = 3
        pick_host_name_from_backend_http_settings = true
        host                                      = null
        match                                     = null
      }

      comps = {
        name                                      = "comps-health"
        protocol                                  = "Http"
        path                                      = "/health"
        interval                                  = 30
        timeout                                   = 30
        unhealthy_threshold                       = 3
        pick_host_name_from_backend_http_settings = true
        host                                      = null
        match                                     = null
      }
    }

    # ==========================================================================
    # HTTP LISTENER
    # ==========================================================================

    http_listeners = {

      rewn-http = {
        name                 = "rewn-http-listener"
        frontend_port_name   = "port-80"
        protocol             = "Http"
        host_name            = "REPLACE_WITH_REWN_HOSTNAME"
        require_sni          = false
        ssl_certificate_name = null
        firewall_policy_id   = null
      }
    }

    # ==========================================================================
    # ROUTING RULE
    # ==========================================================================

    request_routing_rules = {

      rewn-http = {
        name                        = "rewn-http-rule"
        rule_type                   = "Basic"
        priority                    = 100
        http_listener_name          = "rewn-http-listener"
        backend_address_pool_name   = "myiflip-be"
        backend_http_settings_name  = "myiflip-http-settings"
        redirect_configuration_name = null
        rewrite_rule_set_name       = null
        url_path_map_name           = null
      }
    }

    # ==========================================================================
    # REDIRECTS
    # ==========================================================================

    redirect_configurations = {}

    # ==========================================================================
    # SSL CERTIFICATES
    # ==========================================================================

    ssl_certificates = {}

    # ==========================================================================
    # URL PATH MAPS
    # ==========================================================================

    url_path_maps = {}

    # ==========================================================================
    # WAF
    # ==========================================================================

    waf_enabled          = true
    waf_firewall_mode    = "Prevention"
    waf_rule_set_type    = "OWASP"
    waf_rule_set_version = "3.2"

    # ==========================================================================
    # HTTP2
    # ==========================================================================

    enable_http2 = true
  }
}