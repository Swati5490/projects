# ============================================================================
# GENERAL
# ============================================================================

variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group name"
  type        = string
}

variable "tags" {
  description = "Tags for resources"
  type        = map(string)
  default     = {}
}


# ============================================================================
# CREATION FLAGS
# ============================================================================

variable "create_storage_account" {
  type    = bool
  default = false
}

variable "create_container" {
  type    = bool
  default = false
}

variable "create_file_share" {
  type    = bool
  default = false
}

variable "create_private_endpoint" {
  type    = bool
  default = false
}


# ============================================================================
# STORAGE ACCOUNT
# ============================================================================

variable "storage_account_name" {
  type    = string
  default = null
}

variable "account_tier" {
  type    = string
  default = "Standard"
}

variable "account_replication_type" {
  type    = string
  default = "LRS"
}

variable "access_tier" {
  type    = string
  default = "Hot"
}

variable "https_traffic_only_enabled" {
  type    = bool
  default = true
}

variable "public_network_access_enabled" {
  type    = bool
  default = true
}

variable "allow_nested_items_to_be_public" {
  type    = bool
  default = false
}

variable "min_tls_version" {
  type    = string
  default = "TLS1_2"
}


# ============================================================================
# BLOB CONTAINER
# ============================================================================

variable "container_name" {
  type    = string
  default = null
}

variable "container_access_type" {
  type    = string
  default = "private"
}


# ============================================================================
# AZURE FILE SHARE
# ============================================================================

variable "share_name" {
  type    = string
  default = null
}

variable "share_quota" {
  type    = number
  default = null
}


# ============================================================================
# PRIVATE ENDPOINT
# ============================================================================

variable "private_endpoint_name" {
  type    = string
  default = null
}

variable "private_endpoint_subnet_id" {
  type    = string
  default = null
}

variable "private_endpoint_subresource_names" {
  type    = list(string)
  default = []
}
# ============================================================================
# RBAC
# ============================================================================

variable "assign_blob_data_reader" {
  description = "Whether to assign Storage Blob Data Reader role"
  type        = bool
  default     = false
}
