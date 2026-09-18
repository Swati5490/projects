# ============================================================================
# SECURITY VARIABLES
# ============================================================================

variable "key_vaults" {
  description = "Key Vault configurations"

  type = map(object({
    name                       = string
    sku                        = optional(string, "standard")
    purge_protection_enabled   = optional(bool, true)
    soft_delete_retention_days = optional(number, 90)
    enable_rbac_authorization  = optional(bool, true)
    create                     = optional(bool, true)
  }))

  default = {}
}


variable "key_vault_secrets" {
  description = "Key Vault secrets"

  sensitive = true

  type = map(object({
    name         = string
    value        = string
    content_type = optional(string)
    tags         = optional(map(string), {})
  }))

  default = {}
}


variable "managed_identities" {
  description = "Managed identities"

  type = map(object({
    name   = string
    create = optional(bool, true)
  }))

  default = {}
}


variable "federated_identity_credentials" {
  description = "Federated Identity Credentials"

  type = map(object({
    name         = string
    identity_key = string
    audience     = list(string)
    issuer       = string
    subject      = string
    create       = optional(bool, true)
  }))

  default = {}
}


variable "role_assignments" {
  description = "Managed identity role assignments"

  type = map(object({
    name                 = string
    identity_key         = string
    role_definition_name = string
    scope                = string
  }))

  default = {}
}