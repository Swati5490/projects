# Databases Module - variables.tf

variable "server_name" {
  description = "Name of the MySQL server"
  type        = string
  default     = null
}

variable "cosmosdb_account_name" {
  description = "Name of the Cosmos DB account"
  type        = string
  default     = null
}

variable "redis_cache_name" {
  description = "Name of the Redis cache"
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

# MySQL Variables
variable "sku_name" {
  description = "MySQL SKU name"
  type        = string
  default     = "B_Standard_B1s"
}

variable "storage_gb" {
  description = "Storage size in GB"
  type        = number
  default     = 20
}

variable "backup_retention_days" {
  description = "Backup retention days"
  type        = number
  default     = 7
}

variable "geo_redundant_backup_enabled" {
  description = "Enable geo-redundant backups"
  type        = bool
  default     = true
}

variable "zone" {
  description = "Availability zone"
  type        = string
  default     = null
}

variable "auto_grow_enabled" {
  description = "Enable auto-grow"
  type        = bool
  default     = true
}

variable "administrator_login" {
  description = "Administrator login name"
  type        = string
  default     = null
  sensitive   = true
}

variable "database_version" {
  description = "MySQL version"
  type        = string
  default     = "8.0.21"
}

# Cosmos DB Variables
variable "offer_type" {
  description = "Cosmos DB offer type"
  type        = string
  default     = "Standard"
}

variable "kind" {
  description = "Cosmos DB kind"
  type        = string
  default     = "MongoDB"
}

variable "enable_automatic_failover" {
  description = "Enable automatic failover"
  type        = bool
  default     = true
}

variable "enable_multiple_write_locations" {
  description = "Enable multiple write locations"
  type        = bool
  default     = false
}

variable "consistency_level" {
  description = "Cosmos DB consistency level"
  type        = string
  default     = "Session"
}

# Redis Variables
variable "capacity" {
  description = "Redis capacity"
  type        = number
  default     = 1
}

variable "family" {
  description = "Redis family"
  type        = string
  default     = "C"
}

variable "redis_sku_name" {
  description = "Redis SKU name"
  type        = string
  default     = "Standard"
}

variable "enable_non_ssl" {
  description = "Enable non-SSL connections"
  type        = bool
  default     = false
}

variable "minimum_tls_version" {
  description = "Minimum TLS version"
  type        = string
  default     = "1.2"
}

variable "zones" {
  description = "Availability zones"
  type        = list(string)
  default     = []
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
