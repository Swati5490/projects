# ============================================================================
# COSMOS DB - CHILD MODULE VARIABLES
# ============================================================================

# ----------------------------------------------------------------------------
# BASIC CONFIGURATION
# ----------------------------------------------------------------------------

variable "name" {
  description = "Cosmos DB account name"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "kind" {
  description = "Cosmos DB API type"

  type = string

  validation {
    condition = contains(
      ["GlobalDocumentDB", "MongoDB"],
      var.kind
    )

    error_message = "kind must be GlobalDocumentDB or MongoDB."
  }
}

# ----------------------------------------------------------------------------
# MONGODB
# ----------------------------------------------------------------------------

variable "mongo_server_version" {
  description = "MongoDB server version"
  type        = string
  default     = null
}

# ----------------------------------------------------------------------------
# AVAILABILITY / FAILOVER
# ----------------------------------------------------------------------------

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

  validation {
    condition = contains(
      [
        "Strong",
        "BoundedStaleness",
        "Session",
        "Eventual",
        "ConsistentPrefix"
      ],
      var.consistency_level
    )

    error_message = "Invalid Cosmos DB consistency level."
  }
}

# ----------------------------------------------------------------------------
# GEO LOCATIONS
# ----------------------------------------------------------------------------

variable "geo_locations" {
  description = "Cosmos DB geo locations"

  type = list(object({
    location          = string
    failover_priority = number
    zone_redundant    = optional(bool, false)
  }))

  default = []
}

# ----------------------------------------------------------------------------
# NETWORK
# ----------------------------------------------------------------------------

variable "public_network_access_enabled" {
  description = "Enable public network access"
  type        = bool
  default     = false
}

variable "is_virtual_network_filter_enabled" {
  description = "Enable VNet filtering"
  type        = bool
  default     = false
}

variable "ip_range_filter" {
  description = "Allowed IP ranges"
  type        = list(string)
  default     = []
}

# ----------------------------------------------------------------------------
# BACKUP
# ----------------------------------------------------------------------------

variable "backup_type" {
  description = "Cosmos DB backup type"
  type        = string
  default     = "Continuous"

  validation {
    condition = contains(
      ["Continuous", "Periodic"],
      var.backup_type
    )

    error_message = "backup_type must be Continuous or Periodic."
  }
}

# ============================================================================
# MONGODB DATABASES
# ============================================================================

variable "mongo_databases" {
  description = "MongoDB databases"

  type = map(object({
    name       = string
    create     = optional(bool, true)
    throughput = optional(number)
  }))

  default = {}
}

# ============================================================================
# MONGODB COLLECTIONS
# ============================================================================

variable "mongo_collections" {
  description = "MongoDB collections"

  type = map(object({
    name          = string
    database_name = string
    create        = optional(bool, true)
    shard_key     = optional(string)
    throughput    = optional(number)

    indexes = optional(list(object({
      keys   = list(string)
      unique = optional(bool, false)
    })), [])
  }))

  default = {}
}

# ============================================================================
# NOSQL DATABASES
# DynamoDB migration target
# ============================================================================

variable "sql_databases" {
  description = "Cosmos DB NoSQL databases"

  type = map(object({
    name       = string
    create     = optional(bool, true)
    throughput = optional(number)
  }))

  default = {}
}

# ============================================================================
# NOSQL CONTAINERS
# DynamoDB table migration target
# ============================================================================

variable "sql_containers" {
  description = "Cosmos DB NoSQL containers"

  type = map(object({
    name                  = string
    database_name         = string
    partition_key_path    = string
    partition_key_version = optional(number, 2)

    create     = optional(bool, true)
    throughput = optional(number)

    default_ttl   = optional(number)
    indexing_mode = optional(string, "consistent")
  }))

  default = {}
}

# ============================================================================
# PRIVATE ENDPOINT
# ============================================================================

variable "create_private_endpoint" {
  description = "Create Cosmos DB private endpoint"
  type        = bool
  default     = false
}

variable "private_endpoint_name" {
  description = "Cosmos DB private endpoint name"
  type        = string
  default     = null
}

variable "private_endpoint_subresource_names" {
  description = "Cosmos DB private endpoint subresources"
  type        = list(string)
  default     = []
}

variable "private_endpoint_subnet_id" {
  description = "Subnet ID for Cosmos DB private endpoint"
  type        = string
  default     = null
}

# ============================================================================
# COMMON
# ============================================================================

variable "environment" {
  description = "Environment"
  type        = string
}

variable "project_name" {
  description = "Project name"
  type        = string
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
  default     = {}
}
