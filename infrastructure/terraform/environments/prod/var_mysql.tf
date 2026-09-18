# ============================================================================
# MYSQL SERVERS
# ============================================================================

variable "mysql_administrator_password" {
  description = "Administrator password for the MySQL Flexible Server"
  type        = string
  sensitive   = true
  default     = null
}

variable "mysql_servers" {
  description = "MySQL Flexible Server configuration"

  type = map(object({

    # ------------------------------------------------------------------------
    # BASIC CONFIGURATION
    # ------------------------------------------------------------------------

    name               = string
    resource_group_key = string

    sku_name   = string
    version    = string
    storage_gb = number
    zone       = optional(string, null)

    # ------------------------------------------------------------------------
    # BACKUP
    # ------------------------------------------------------------------------

    backup_retention_days        = number
    geo_redundant_backup_enabled = bool

    # ------------------------------------------------------------------------
    # STORAGE
    # ------------------------------------------------------------------------

    auto_grow_enabled = bool

    # ------------------------------------------------------------------------
    # ADMINISTRATOR
    # ------------------------------------------------------------------------

    administrator_login = string

    # ------------------------------------------------------------------------
    # CONFIGURATIONS
    # ------------------------------------------------------------------------

    configurations = optional(map(object({
      name  = string
      value = string
    })), {})

    # ------------------------------------------------------------------------
    # PRIVATE ENDPOINT
    # ------------------------------------------------------------------------

    private_endpoint = optional(object({
      name              = string
      subresource_names = list(string)
      subnet_key        = string
    }))

    # ------------------------------------------------------------------------
    # CREATE
    # ------------------------------------------------------------------------

    create = bool
  }))

  default = {}
}

variable "mysql_region" {
  description = "Azure region for MySQL Flexible Server"
  type        = string
  default     = null
}