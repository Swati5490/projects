# Storage Module - variables.tf

variable "storage_account_name" {
  description = "Name of the storage account"
  type        = string
  default     = null
}

variable "container_name" {
  description = "Name of the blob container"
  type        = string
  default     = null
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure location"
  type        = string
}

variable "account_tier" {
  description = "Storage account tier (Standard, Premium)"
  type        = string
  default     = "Standard"
}

variable "account_replication_type" {
  description = "Replication type (LRS, GRS, RAGRS, ZRS)"
  type        = string
  default     = "GRS"
}

variable "access_tier" {
  description = "Access tier (Hot, Cool, Archive)"
  type        = string
  default     = "Hot"
}

variable "https_traffic_only_enabled" {
  description = "Only allow HTTPS traffic"
  type        = bool
  default     = true
}

variable "min_tls_version" {
  description = "Minimum TLS version"
  type        = string
  default     = "TLS1_2"
}

variable "blob_delete_retention" {
  description = "Blob soft delete retention days"
  type        = number
  default     = 7
}

variable "versioning_enabled" {
  description = "Enable blob versioning"
  type        = bool
  default     = true
}

variable "container_access_type" {
  description = "Container access type (private, blob, container)"
  type        = string
  default     = "private"
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
  description = "Tags to apply"
  type        = map(string)
  default     = {}
}

variable "share_name" {
  description = "Name of the Azure file share"
  type        = string
  default     = null
}

variable "share_quota" {
  description = "Quota for Azure file share in GB"
  type        = number
  default     = 100
}
