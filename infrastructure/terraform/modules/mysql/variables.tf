# ============================================================================
# MYSQL DATABASE MODULE VARIABLES
# ============================================================================

variable "name" {
  description = "Name of the MySQL Flexible Server"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name for MySQL"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "sku_name" {
  description = "MySQL Flexible Server SKU"
  type        = string
}

variable "mysql_version" {
  description = "MySQL version"
  type        = string
}

variable "storage_gb" {
  description = "MySQL storage size in GB"
  type        = number
}

variable "zone" {
  description = "Availability zone for MySQL"
  type        = string
  default     = null
}


# ============================================================================
# BACKUP
# ============================================================================

variable "backup_retention_days" {
  description = "Backup retention period in days"
  type        = number
  default     = 7
}

variable "geo_redundant_backup_enabled" {
  description = "Enable geo-redundant backup"
  type        = bool
  default     = false
}


# ============================================================================
# STORAGE
# ============================================================================

variable "auto_grow_enabled" {
  description = "Enable storage auto-grow"
  type        = bool
  default     = true
}


# ============================================================================
# ADMINISTRATOR
# ============================================================================

variable "administrator_login" {
  description = "MySQL administrator username"
  type        = string
}

variable "administrator_password" {
  description = "MySQL administrator password"
  type        = string
  sensitive   = true
  default     = null
}


# ============================================================================
# MYSQL CONFIGURATIONS
# ============================================================================

variable "configurations" {
  description = "MySQL Flexible Server configurations"

  type = map(object({
    name  = string
    value = string
  }))

  default = {}
}


# ============================================================================
# PRIVATE ENDPOINT
# ============================================================================

variable "create_private_endpoint" {
  description = "Whether to create a private endpoint"
  type        = bool
  default     = false
}

variable "private_endpoint_name" {
  description = "Name of the MySQL private endpoint"
  type        = string
  default     = null
}

variable "private_endpoint_subresource_names" {
  description = "Private endpoint subresource names"
  type        = list(string)
  default     = []
}

variable "private_endpoint_subnet_id" {
  description = "Subnet ID for the private endpoint"
  type        = string
  default     = null
}


# ============================================================================
# COMMON
# ============================================================================

variable "environment" {
  description = "Environment name"
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