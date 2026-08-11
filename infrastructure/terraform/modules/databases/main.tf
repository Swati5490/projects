# Databases Module - main.tf

# Azure Database for MySQL Flexible Server
resource "azurerm_mysql_flexible_server" "main" {
  count = var.server_name != null ? 1 : 0

  name                   = var.server_name
  resource_group_name    = var.resource_group_name
  location               = var.location
  administrator_login    = var.administrator_login
  backup_retention_days  = var.backup_retention_days
  geo_redundant_backup_enabled = var.geo_redundant_backup_enabled
  zone                   = var.zone
  sku_name               = var.sku_name
  version                = var.database_version
  storage {
    iops    = 360
    size_gb = var.storage_gb
  }

  high_availability {
    mode = "ZoneRedundant"
  }

  tags = merge(
    var.tags,
    {
      Environment = var.environment
    }
  )
}

# Cosmos DB Account
resource "azurerm_cosmosdb_account" "main" {
  count = var.cosmosdb_account_name != null ? 1 : 0

  name                = var.cosmosdb_account_name
  location            = var.location
  resource_group_name = var.resource_group_name
  offer_type          = var.offer_type
  kind                = var.kind

  consistency_policy {
    consistency_level = var.consistency_level
  }

  geo_location {
    location          = var.location
    failover_priority = 0
  }

  tags = merge(
    var.tags,
    {
      Environment = var.environment
    }
  )
}

# Azure Cache for Redis
resource "azurerm_redis_cache" "main" {
  count = var.redis_cache_name != null ? 1 : 0

  name                = var.redis_cache_name
  location            = var.location
  resource_group_name = var.resource_group_name
  capacity            = var.capacity
  family              = var.family
  sku_name            = var.redis_sku_name
  minimum_tls_version = var.minimum_tls_version
  zones               = length(var.zones) > 0 ? var.zones : null

  tags = merge(
    var.tags,
    {
      Environment = var.environment
    }
  )
}
