# ============================================================================
# KEY VAULT
# ============================================================================

variable "key_vault_name" {
  description = "Name of the Key Vault"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "tenant_id" {
  description = "Microsoft Entra tenant ID"
  type        = string
}

variable "sku_name" {
  description = "Key Vault SKU"
  type        = string
  default     = "standard"
}

variable "purge_protection_enabled" {
  description = "Enable Key Vault purge protection"
  type        = bool
  default     = true
}

variable "soft_delete_retention_days" {
  description = "Key Vault soft delete retention period"
  type        = number
  default     = 90
}

variable "enable_rbac_authorization" {
  description = "Enable Azure RBAC authorization for Key Vault"
  type        = bool
  default     = true
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
  default     = {}
}


# ============================================================================
# KEY VAULT SECRETS
# ============================================================================

variable "key_vault_secrets" {
  description = "Key Vault secrets"
  sensitive   = true

  type = map(object({
    name         = string
    value        = string
    content_type = optional(string)
    tags         = optional(map(string), {})
  }))

  default = {}
}


# ============================================================================
# MANAGED IDENTITIES
# ============================================================================

variable "managed_identities" {
  description = "User Assigned Managed Identities"

  type = map(object({
    name   = string
    create = optional(bool, true)
  }))

  default = {}
}


# ============================================================================
# FEDERATED IDENTITY CREDENTIALS
# ============================================================================

variable "federated_credentials" {
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


# ============================================================================
# ROLE ASSIGNMENTS
# ============================================================================

variable "role_assignments" {
  description = "Role assignments for managed identities"

  type = map(object({
    name                 = string
    identity_key         = string
    role_definition_name = string
    scope                = string
  }))

  default = {}
}