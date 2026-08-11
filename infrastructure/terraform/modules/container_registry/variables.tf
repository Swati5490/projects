# Azure Container Registry Module - variables.tf

variable "registry_name" {
  description = "Name of the container registry"
  type        = string
  default     = null
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = null
}

variable "location" {
  description = "Azure region location"
  type        = string
  default     = null
}

variable "sku" {
  description = "The SKU name of the container registry (Basic, Standard, Premium)"
  type        = string
  default     = "Premium"
}

variable "admin_enabled" {
  description = "Specifies whether the admin user is enabled"
  type        = bool
  default     = false
}

variable "public_network_access_enabled" {
  description = "Whether public network access is allowed"
  type        = bool
  default     = false
}

variable "zone_redundancy_enabled" {
  description = "Whether zone redundancy is enabled (Premium only)"
  type        = bool
  default     = true
}

variable "export_policy_enabled" {
  description = "Whether export policy is enabled"
  type        = bool
  default     = true
}

variable "data_endpoint_enabled" {
  description = "Whether dedicated data endpoints are enabled"
  type        = bool
  default     = false
}

variable "network_rule_bypass_option" {
  description = "Whether to allow trusted Azure services to bypass firewall rules"
  type        = string
  default     = "AzureServices"
}

variable "anonymous_pull_enabled" {
  description = "Whether anonymous pull is enabled"
  type        = bool
  default     = false
}

variable "encryption_enabled" {
  description = "Whether CMK encryption is enabled"
  type        = bool
  default     = false
}

variable "encryption_key_vault_key_id" {
  description = "Key Vault Key ID for encryption"
  type        = string
  default     = null
}

variable "identity_type" {
  description = "Type of managed identity (SystemAssigned, UserAssigned)"
  type        = string
  default     = "SystemAssigned"
}

variable "identity_ids" {
  description = "List of user-assigned identity IDs"
  type        = list(string)
  default     = []
}

variable "quarantine_policy_enabled" {
  description = "Whether quarantine policy is enabled"
  type        = bool
  default     = false
}

variable "retention_policy_days" {
  description = "Number of days to keep untagged manifests"
  type        = number
  default     = 30
}

variable "trust_policy_enabled" {
  description = "Whether content trust is enabled"
  type        = bool
  default     = false
}

variable "webhooks" {
  description = "Map of ACR webhooks"
  type = map(object({
    name           = string
    service_uri    = string
    custom_headers = optional(map(string))
    status         = optional(string, "enabled")
    scope          = optional(string, "")
    actions        = optional(list(string), ["push", "delete"])
  }))
  default = {}
}

variable "tasks" {
  description = "Map of ACR tasks for automated builds"
  type = map(object({
    name                       = string
    enabled                    = optional(bool, true)
    is_system_task            = optional(bool, false)
    image_names               = list(string)
    dockerfile_path           = string
    context_access_token      = string
    context_path              = string
    push_enabled              = optional(bool, true)
    cache_enabled             = optional(bool, true)
    platform_os               = optional(string, "Linux")
    platform_architecture     = optional(string, "amd64")
    timer_trigger_enabled     = optional(bool, false)
    timer_trigger_schedule    = optional(string, "")
  }))
  default = {}
}

variable "aks_principal_id" {
  description = "Principal ID of AKS cluster for ACR pull access"
  type        = string
  default     = null
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "prod"
}

variable "project_name" {
  description = "Project name for tagging"
  type        = string
  default     = "rewn"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
