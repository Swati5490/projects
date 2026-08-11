# Production Front Door Configuration
# Common/Shared infrastructure serving both Prod and Dev
# Usage: terraform plan -var-file="environments/prod/_globals.tfvars" -var-file="environments/prod/front_door.tfvars"

# ============================================================================
# FRONT DOOR - Global Entry Point for Prod & Dev
# ============================================================================
front_doors = {
  main = {
    name              = "fd-rewn"
    sku_name          = "Standard_AzureFrontDoor"
    enforce_https     = true
    http_to_https_redirect = true
    enable_waf        = true
    waf_policy_mode   = "Detection"
    
    backend_pools = {
      prodpool = {
        name                = "prod-backend-pool"
        session_affinity    = "Disabled"
        load_balancing_name = "prod-lb"
        backends = [
          {
            address = "appgw-rewn-cin.azureedge.net"
            port    = 443
          }
        ]
      }
      devpool = {
        name                = "dev-backend-pool"
        session_affinity    = "Disabled"
        load_balancing_name = "dev-lb"
        backends = [
          {
            address = "appgw-rewn-cin.azureedge.net"
            port    = 443
          }
        ]
      }
    }
    
    frontend_endpoints = {
      prod_endpoint = {
        host_name = "prod.rewn.io"
      }
      dev_endpoint = {
        host_name = "dev.rewn.io"
      }
      cdn_endpoint = {
        host_name = "cdn.rewn.io"
      }
    }
    
    routing_rules = {
      prod-route = {
        frontend_endpoint_name = "prod_endpoint"
        backend_pool_name      = "prodpool"
        pattern_to_match       = "/*"
        accepted_protocols     = ["Http", "Https"]
      }
      dev-route = {
        frontend_endpoint_name = "dev_endpoint"
        backend_pool_name      = "devpool"
        pattern_to_match       = "/*"
        accepted_protocols     = ["Http", "Https"]
      }
    }
  }
}
