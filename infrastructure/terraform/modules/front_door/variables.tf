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

variable "front_door_name" {
  description = "Name of Front Door"
  type        = string
  default     = null
}

variable "sku_name" {
  description = "SKU name (Standard or Premium)"
  type        = string
  default     = "Standard_AzureFrontDoor"
}

variable "enforce_https" {
  description = "Enforce HTTPS"
  type        = bool
  default     = true
}

variable "http_to_https_redirect" {
  description = "Enable HTTP to HTTPS redirect"
  type        = bool
  default     = true
}

variable "backend_pools" {
  description = "Backend pools configuration"
  type = map(object({
    name                = string
    session_affinity    = optional(string, "Disabled")
    load_balancing_name = optional(string)
    backends = list(object({
      address = string
      port    = optional(number, 443)
    }))
  }))
  default = {}
}

variable "frontend_endpoints" {
  description = "Frontend endpoints configuration"
  type = map(object({
    host_name = string
  }))
  default = {}
}

variable "routing_rules" {
  description = "Routing rules configuration"
  type = map(object({
    frontend_endpoint_name = string
    backend_pool_name      = string
    pattern_to_match       = optional(string, "/*")
    accepted_protocols     = optional(list(string), ["Http", "Https"])
  }))
  default = {}
}

variable "enable_waf" {
  description = "Enable WAF"
  type        = bool
  default     = false
}

variable "waf_policy_mode" {
  description = "WAF policy mode (Detection or Prevention)"
  type        = string
  default     = "Detection"
}
