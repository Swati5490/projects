# ============================================================================
# COSMOS DB ACCOUNT OUTPUTS
# ============================================================================

output "id" {
  description = "Cosmos DB account resource ID"
  value       = azurerm_cosmosdb_account.main.id
}

output "name" {
  description = "Cosmos DB account name"
  value       = azurerm_cosmosdb_account.main.name
}

output "endpoint" {
  description = "Cosmos DB endpoint"
  value       = azurerm_cosmosdb_account.main.endpoint
}

output "primary_key" {
  description = "Primary Cosmos DB account key"
  value       = azurerm_cosmosdb_account.main.primary_key
  sensitive   = true
}

output "secondary_key" {
  description = "Secondary Cosmos DB account key"
  value       = azurerm_cosmosdb_account.main.secondary_key
  sensitive   = true
}

output "primary_readonly_key" {
  description = "Primary read-only Cosmos DB key"
  value       = azurerm_cosmosdb_account.main.primary_readonly_key
  sensitive   = true
}

output "secondary_readonly_key" {
  description = "Secondary read-only Cosmos DB key"
  value       = azurerm_cosmosdb_account.main.secondary_readonly_key
  sensitive   = true
}


# ============================================================================
# MONGODB OUTPUTS
# ============================================================================

output "mongo_database_ids" {
  description = "MongoDB database IDs"
  value = {
    for key, database in azurerm_cosmosdb_mongo_database.main :
    key => database.id
  }
}

output "mongo_database_names" {
  description = "MongoDB database names"
  value = {
    for key, database in azurerm_cosmosdb_mongo_database.main :
    key => database.name
  }
}

output "mongo_collection_ids" {
  description = "MongoDB collection IDs"
  value = {
    for key, collection in azurerm_cosmosdb_mongo_collection.main :
    key => collection.id
  }
}

output "mongo_collection_names" {
  description = "MongoDB collection names"
  value = {
    for key, collection in azurerm_cosmosdb_mongo_collection.main :
    key => collection.name
  }
}


# ============================================================================
# NOSQL OUTPUTS
# ============================================================================

output "sql_database_ids" {
  description = "Cosmos DB NoSQL database IDs"
  value = {
    for key, database in azurerm_cosmosdb_sql_database.main :
    key => database.id
  }
}

output "sql_database_names" {
  description = "Cosmos DB NoSQL database names"
  value = {
    for key, database in azurerm_cosmosdb_sql_database.main :
    key => database.name
  }
}

output "sql_container_ids" {
  description = "Cosmos DB NoSQL container IDs"
  value = {
    for key, container in azurerm_cosmosdb_sql_container.main :
    key => container.id
  }
}

output "sql_container_names" {
  description = "Cosmos DB NoSQL container names"
  value = {
    for key, container in azurerm_cosmosdb_sql_container.main :
    key => container.name
  }
}


# ============================================================================
# PRIVATE ENDPOINT OUTPUT
# ============================================================================

output "private_endpoint_id" {
  description = "Cosmos DB private endpoint ID"
  value       = try(azurerm_private_endpoint.cosmos[0].id, null)
}

output "private_endpoint_name" {
  description = "Cosmos DB private endpoint name"
  value       = try(azurerm_private_endpoint.cosmos[0].name, null)
}

output "private_endpoint_ip" {
  description = "Cosmos DB private endpoint private IP"
  value = try(
    azurerm_private_endpoint.cosmos[0].private_service_connection[0].private_ip_address,
    null
  )
}