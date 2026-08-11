# Production Application Gateway Configuration
# Common/Shared infrastructure serving both Prod and Dev
# Usage: terraform plan -var-file="environments/prod/_globals.tfvars" -var-file="environments/prod/application_gateway.tfvars"

# ============================================================================
# APPLICATION GATEWAY - Shared Entry Point (Prod Region)
# ============================================================================
application_gateways = {
  main = {
    name                = "appgw-rewn-cin"
    sku_name            = "Standard_v2"
    sku_tier            = "Standard"
    capacity            = 2
    public_ip_name      = "pip-appgw-rewn-cin"
    enable_http2        = true
    enable_waf          = false
    
    backend_pools = {
      prod_aks = {
        name = "bp-prod-aks"
        fqdns = []
        ips   = []
      }
      dev_aks = {
        name = "bp-dev-aks"
        fqdns = []
        ips   = []
      }
      prod_services = {
        name = "bp-prod-services"
        fqdns = []
        ips   = []
      }
      dev_services = {
        name = "bp-dev-services"
        fqdns = []
        ips   = []
      }
    }
    
    http_settings = {
      default_http = {
        cookie_based_affinity = "Disabled"
        port                  = 80
        protocol              = "Http"
        request_timeout       = 30
      }
      https_settings = {
        cookie_based_affinity = "Disabled"
        port                  = 443
        protocol              = "Https"
        request_timeout       = 30
      }
    }
    
    http_listeners = {
      http_listener = {
        port             = 80
        protocol         = "Http"
        host_name        = null
        require_sni      = false
        ssl_certificate_name = null
      }
      https_listener = {
        port             = 443
        protocol         = "Https"
        host_name        = null
        require_sni      = false
        ssl_certificate_name = null
      }
    }
    
    request_routing_rules = {
      prod_rule = {
        rule_type            = "Basic"
        http_listener_name   = "http_listener"
        backend_pool_name    = "bp-prod-aks"
        http_settings_name   = "default_http"
        redirect_config_name = null
      }
      dev_rule = {
        rule_type            = "Basic"
        http_listener_name   = "http_listener"
        backend_pool_name    = "bp-dev-aks"
        http_settings_name   = "default_http"
        redirect_config_name = null
      }
    }
    
    zones = ["1", "2", "3"]
  }
}
