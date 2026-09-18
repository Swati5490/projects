# ============================================================================
# APPLICATION GATEWAY MODULE VARIABLES
# ============================================================================

variable "application_gateways" {
  description = "Application Gateway configuration"

  type = map(object({

    # ------------------------------------------------------------------------
    # BASIC
    # ------------------------------------------------------------------------

    name = string

    sku_name = string
    sku_tier = string

    capacity = number

    enable_autoscale       = bool
    autoscale_min_capacity = number
    autoscale_max_capacity = number

    # ------------------------------------------------------------------------
    # FRONTEND
    # ------------------------------------------------------------------------

    public_ip_address_id = string

    frontend_ip_configuration_name = string

    frontend_ports = map(object({
      name = string
      port = number
    }))

    # ------------------------------------------------------------------------
    # BACKEND ADDRESS POOLS
    # ------------------------------------------------------------------------

    backend_address_pools = map(object({
      name         = string
      fqdns        = list(string)
      ip_addresses = list(string)
    }))

    # ------------------------------------------------------------------------
    # BACKEND HTTP SETTINGS
    # ------------------------------------------------------------------------

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

    # ------------------------------------------------------------------------
    # HTTP LISTENERS
    # ------------------------------------------------------------------------

    http_listeners = map(object({
      name                           = string
      frontend_port_name             = string
      protocol                       = string
      host_name                      = optional(string, null)
      require_sni                    = optional(bool, false)
      ssl_certificate_name           = optional(string, null)
      firewall_policy_id             = optional(string, null)
    }))

    # ------------------------------------------------------------------------
    # REQUEST ROUTING RULES
    # ------------------------------------------------------------------------

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

    # ------------------------------------------------------------------------
    # HEALTH PROBES
    # ------------------------------------------------------------------------

    probes = map(object({
      name                                      = string
      protocol                                  = string
      path                                      = string
      interval                                  = number
      timeout                                   = number
      unhealthy_threshold                       = number
      pick_host_name_from_backend_http_settings = optional(bool, false)
      host                                      = optional(string, null)

      match = optional(object({
        status_code = list(string)
      }), null)
    }))

    # ------------------------------------------------------------------------
    # SSL CERTIFICATES
    # ------------------------------------------------------------------------

    ssl_certificates = map(object({
      name                = string
      key_vault_secret_id = string
    }))

    # ------------------------------------------------------------------------
    # URL PATH MAPS
    # ------------------------------------------------------------------------

    url_path_maps = map(object({
      name                               = string
      default_backend_address_pool_name  = string
      default_backend_http_settings_name = string

      path_rules = map(object({
        name                       = string
        paths                      = list(string)
        backend_address_pool_name  = optional(string, null)
        backend_http_settings_name = optional(string, null)
      }))
    }))

    # ------------------------------------------------------------------------
    # REDIRECT CONFIGURATIONS
    # ------------------------------------------------------------------------

    redirect_configurations = map(object({
      name                 = string
      redirect_type        = string
      target_listener_name = optional(string, null)
      target_url           = optional(string, null)
      include_path         = optional(bool, true)
      include_query_string = optional(bool, true)
    }))

    # ------------------------------------------------------------------------
    # WAF
    # ------------------------------------------------------------------------

    waf_enabled          = bool
    waf_firewall_mode    = string
    waf_rule_set_type    = string
    waf_rule_set_version = string
    firewall_policy_id   = optional(string, null)

    # ------------------------------------------------------------------------
    # HTTP2
    # ------------------------------------------------------------------------

    enable_http2 = bool

    # ------------------------------------------------------------------------
    # ROOT MODULE LOOKUP KEYS
    # These are consumed before the values reach the child resource.
    # ------------------------------------------------------------------------

    resource_group_key   = optional(string, null)
    subnet_key            = optional(string, null)
    public_ip_key         = optional(string, null)
    managed_identity_key = optional(string, null)

    # ------------------------------------------------------------------------
    # These are injected by root main.tf using merge()
    # ------------------------------------------------------------------------

    resource_group_name = optional(string, null)
    subnet_id           = optional(string, null)
    managed_identity_id = optional(string, null)
  }))

  default = {}
}


# ============================================================================
# LOCATION
# ============================================================================

variable "location" {
  description = "Azure region"
  type        = string
}


# ============================================================================
# COMMON TAGGING
# ============================================================================

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "project_name" {
  description = "Project name"
  type        = string
}

variable "tags" {
  description = "Common resource tags"
  type        = map(string)
  default     = {}
}