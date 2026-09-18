# ============================================================================
# COSMOS DB ACCOUNT
# ============================================================================

resource "azurerm_cosmosdb_account" "main" {

  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  offer_type = "Standard"
  kind       = var.kind

  # Required only for MongoDB API
  mongo_server_version = var.kind == "MongoDB" ? var.mongo_server_version : null

  automatic_failover_enabled = var.enable_automatic_failover

  multiple_write_locations_enabled = var.enable_multiple_write_locations

  consistency_policy {
    consistency_level = var.consistency_level
  }

  # --------------------------------------------------------------------------
  # GEO LOCATIONS
  # --------------------------------------------------------------------------

  dynamic "geo_location" {
    for_each = var.geo_locations

    content {
      location          = geo_location.value.location
      failover_priority = geo_location.value.failover_priority
      zone_redundant    = try(geo_location.value.zone_redundant, false)
    }
  }

  # --------------------------------------------------------------------------
  # NETWORK
  # --------------------------------------------------------------------------

  public_network_access_enabled = var.public_network_access_enabled

  is_virtual_network_filter_enabled = var.is_virtual_network_filter_enabled

  ip_range_filter = var.ip_range_filter

  # --------------------------------------------------------------------------
  # BACKUP
  # --------------------------------------------------------------------------

  backup {
    type = var.backup_type
  }

  # --------------------------------------------------------------------------
  # MONGODB CAPABILITY
  # --------------------------------------------------------------------------

  dynamic "capabilities" {
    for_each = var.kind == "MongoDB" ? [1] : []

    content {
      name = "EnableMongo"
    }
  }

  # --------------------------------------------------------------------------
  # TAGS
  # --------------------------------------------------------------------------

  tags = merge(
    var.tags,
    {
      Environment = var.environment
      Project     = var.project_name
    }
  )
}


# ============================================================================
# MONGODB DATABASE
# ============================================================================

resource "azurerm_cosmosdb_mongo_database" "main" {

  for_each = {
    for key, database in var.mongo_databases :
    key => database
    if database.create
  }

  name                = each.value.name
  resource_group_name = var.resource_group_name
  account_name        = azurerm_cosmosdb_account.main.name

  throughput = try(each.value.throughput, null)
}


# ============================================================================
# MONGODB COLLECTION
# ============================================================================

resource "azurerm_cosmosdb_mongo_collection" "main" {

  for_each = {
    for key, collection in var.mongo_collections :
    key => collection
    if collection.create
  }

  name                = each.value.name
  resource_group_name = var.resource_group_name
  account_name        = azurerm_cosmosdb_account.main.name
  database_name       = each.value.database_name

  shard_key = try(each.value.shard_key, null)

  throughput = try(each.value.throughput, null)

  dynamic "index" {
    for_each = try(each.value.indexes, [])

    content {
      keys   = index.value.keys
      unique = try(index.value.unique, false)
    }
  }
}


# ============================================================================
# NOSQL DATABASE
# DynamoDB migration target
# ============================================================================

resource "azurerm_cosmosdb_sql_database" "main" {

  for_each = {
    for key, database in var.sql_databases :
    key => database
    if database.create
  }

  name                = each.value.name
  resource_group_name = var.resource_group_name
  account_name        = azurerm_cosmosdb_account.main.name

  throughput = try(each.value.throughput, null)
}


# ============================================================================
# NOSQL CONTAINER
# DynamoDB table migration target
# ============================================================================

resource "azurerm_cosmosdb_sql_container" "main" {

  for_each = {
    for key, container in var.sql_containers :
    key => container
    if container.create
  }

  name                = each.value.name
  resource_group_name = var.resource_group_name
  account_name        = azurerm_cosmosdb_account.main.name
  database_name       = each.value.database_name

  partition_key_paths   = [each.value.partition_key_path]
  partition_key_version = try(each.value.partition_key_version, 2)

  throughput = try(each.value.throughput, null)

  default_ttl = try(each.value.default_ttl, null)

  indexing_policy {
    indexing_mode = try(each.value.indexing_mode, "consistent")

    included_path {
      path = "/*"
    }
  }
}


# ============================================================================
# PRIVATE ENDPOINT
# ============================================================================

resource "azurerm_private_endpoint" "cosmos" {

  count = var.create_private_endpoint ? 1 : 0

  name                = var.private_endpoint_name
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = "${var.name}-private-connection"
    private_connection_resource_id = azurerm_cosmosdb_account.main.id
    is_manual_connection           = false
    subresource_names              = var.private_endpoint_subresource_names
  }

  tags = merge(
    var.tags,
    {
      Environment = var.environment
      Project     = var.project_name
    }
  )
}