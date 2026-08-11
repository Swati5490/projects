# Databases Module - outputs.tf

output "mysql_server_id" {
  description = "The ID of the MySQL server"
  value       = try(azurerm_mysql_flexible_server.main[0].id, null)
}

output "mysql_server_name" {
  description = "The name of the MySQL server"
  value       = try(azurerm_mysql_flexible_server.main[0].name, null)
}

output "mysql_fqdn" {
  description = "The FQDN of the MySQL server"
  value       = try(azurerm_mysql_flexible_server.main[0].fqdn, null)
}

output "cosmosdb_account_id" {
  description = "The ID of the Cosmos DB account"
  value       = try(azurerm_cosmosdb_account.main[0].id, null)
}

output "cosmosdb_account_name" {
  description = "The name of the Cosmos DB account"
  value       = try(azurerm_cosmosdb_account.main[0].name, null)
}

output "cosmosdb_endpoint" {
  description = "The endpoint of the Cosmos DB account"
  value       = try(azurerm_cosmosdb_account.main[0].endpoint, null)
}

output "redis_cache_id" {
  description = "The ID of the Redis cache"
  value       = try(azurerm_redis_cache.main[0].id, null)
}

output "redis_cache_name" {
  description = "The name of the Redis cache"
  value       = try(azurerm_redis_cache.main[0].name, null)
}

output "hostname" {
  description = "The hostname of the Redis cache"
  value       = try(azurerm_redis_cache.main[0].hostname, null)
}

output "port" {
  description = "The port of the Redis cache"
  value       = try(azurerm_redis_cache.main[0].port, null)
}

output "ssl_port" {
  description = "The SSL port of the Redis cache"
  value       = try(azurerm_redis_cache.main[0].ssl_port, null)
}
