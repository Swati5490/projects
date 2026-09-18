# ============================================================================
# COSMOS DB - MONGODB
# ============================================================================

variable "cosmos_mongo_accounts" {
  description = "Cosmos DB accounts using MongoDB API"

  type = map(object({

    # ------------------------------------------------------------------------
    # BASIC
    # ------------------------------------------------------------------------

    name               = string
    resource_group_key = string

    # ------------------------------------------------------------------------
    # MONGODB
    # ------------------------------------------------------------------------

    mongo_server_version = optional(string, null)

    # ------------------------------------------------------------------------
    # AVAILABILITY / FAILOVER
    # ------------------------------------------------------------------------

    enable_automatic_failover = optional(bool, true)

    enable_multiple_write_locations = optional(bool, false)

    consistency_level = optional(string, "Session")

    geo_locations = optional(list(object({
      location          = string
      failover_priority = number
      zone_redundant    = optional(bool, false)
    })), [])

    # ------------------------------------------------------------------------
    # MONGODB DATABASES
    # ------------------------------------------------------------------------

    mongo_databases = optional(map(object({
      name       = string
      create     = optional(bool, true)
      throughput = optional(number)
    })), {})

    # ------------------------------------------------------------------------
    # MONGODB COLLECTIONS
    # ------------------------------------------------------------------------

    mongo_collections = optional(map(object({
      name          = string
      database_name = string
      create        = optional(bool, true)

      shard_key = optional(string)
      throughput = optional(number)

      indexes = optional(list(object({
        keys   = list(string)
        unique = optional(bool, false)
      })), [])
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


# ============================================================================
# COSMOS DB - NOSQL
# DynamoDB migration target
# ============================================================================

variable "cosmos_nosql_accounts" {
  description = "Cosmos DB accounts using NoSQL API"

  type = map(object({

    # ------------------------------------------------------------------------
    # BASIC
    # ------------------------------------------------------------------------

    name               = string
    resource_group_key = string

    # ------------------------------------------------------------------------
    # API
    # ------------------------------------------------------------------------

    kind = optional(string, "GlobalDocumentDB")

    # ------------------------------------------------------------------------
    # AVAILABILITY / FAILOVER
    # ------------------------------------------------------------------------

    enable_automatic_failover = optional(bool, true)

    enable_multiple_write_locations = optional(bool, false)

    consistency_level = optional(string, "Session")

    geo_locations = optional(list(object({
      location          = string
      failover_priority = number
      zone_redundant    = optional(bool, false)
    })), [])

    # ------------------------------------------------------------------------
    # NOSQL DATABASES
    # ------------------------------------------------------------------------

    sql_databases = optional(map(object({
      name       = string
      create     = optional(bool, true)
      throughput = optional(number)
    })), {})

    # ------------------------------------------------------------------------
    # NOSQL CONTAINERS
    # ------------------------------------------------------------------------

    sql_containers = optional(map(object({
      name                  = string
      database_name         = string
      partition_key_path    = string
      partition_key_version = optional(number, 2)

      create     = optional(bool, true)
      throughput = optional(number)

      default_ttl   = optional(number)
      indexing_mode = optional(string, "consistent")
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