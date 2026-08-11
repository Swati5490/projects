variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "project_name" {
  description = "Project name"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "appgw_name" {
  description = "Name of Application Gateway"
  type        = string
  default     = null
}

variable "sku_name" {
  description = "SKU name for AppGW (Standard_v2 or WAF_v2)"
  type        = string
  default     = "Standard_v2"
}

variable "sku_tier" {
  description = "SKU tier (Standard or WAF)"
  type        = string
  default     = "Standard"
}

variable "capacity" {
  description = "Number of instances"
  type        = number
  default     = 2
}

variable "subnet_id" {
  description = "Subnet ID where AppGW will be deployed"
  type        = string
}

variable "public_ip_name" {
  description = "Public IP name for AppGW"
  type        = string
  default     = null
}

variable "backend_address_pools" {
  description = "Backend address pools configuration"
  type = map(object({
    name = string
    fqdns = optional(list(string))
    ips   = optional(list(string))
  }))
  default = {}
}

variable "http_settings" {
  description = "HTTP settings configuration"
  type = map(object({
    cookie_based_affinity = optional(string, "Disabled")
    port                  = optional(number, 80)
    protocol              = optional(string, "Http")
    request_timeout       = optional(number, 30)
  }))
  default = {}
}

variable "http_listeners" {
  description = "HTTP listeners configuration"
  type = map(object({
    port                     = number
    protocol                 = optional(string, "Http")
    host_name                = optional(string)
    require_sni              = optional(bool, false)
    ssl_certificate_name     = optional(string)
  }))
  default = {}
}

variable "request_routing_rules" {
  description = "Request routing rules"
  type = map(object({
    rule_type            = string
    http_listener_name   = string
    backend_pool_name    = optional(string)
    http_settings_name   = optional(string)
    redirect_config_name = optional(string)
  }))
  default = {}
}

variable "enable_waf" {
  description = "Enable WAF on AppGW"
  type        = bool
  default     = false
}

variable "waf_mode" {
  description = "WAF mode (Detection or Prevention)"
  type        = string
  default     = "Detection"
}

variable "zones" {
  description = "Availability zones"
  type        = list(string)
  default     = []
}
