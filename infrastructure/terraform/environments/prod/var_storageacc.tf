# ============================================================================
# STORAGE ACCOUNTS
# ============================================================================

variable "storage_accounts" {
  type = map(object({

    name               = string
    resource_group_key = string

    account_tier             = string
    account_replication_type = string
    access_tier              = string

    https_traffic_only_enabled      = bool
    public_network_access_enabled   = bool
    allow_nested_items_to_be_public = bool

    min_tls_version       = string
    blob_delete_retention = number
    versioning_enabled    = bool

    #assign_blob_data_contributor = optional(bool, false)
    assign_blob_data_reader      = optional(bool, false)
    create = bool

    private_endpoint = optional(object({
      name              = string
      subresource_names = list(string)
      subnet_key        = string
    }))
  }))
}


# ============================================================================
# BLOB CONTAINERS
# ============================================================================

variable "blob_containers" {
  description = "Blob containers configuration"

  type = map(object({
    name                  = string
    storage_account_key   = string
    container_access_type = string
    create                = bool
  }))

  default = {}
}

# ============================================================================
# AZURE FILE SHARES
# ============================================================================

variable "file_shares" {
  description = "Azure File Shares configuration"

  type = map(object({
    name                = string
    storage_account_key = string
    quota               = number
    create              = bool
  }))

  default = {}
}