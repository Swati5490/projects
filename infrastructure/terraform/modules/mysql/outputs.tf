# Databases Module - outputs.tf

output "mysql_server_id" {
  description = "The ID of the MySQL server"
  value       = azurerm_mysql_flexible_server.main.id
}

output "mysql_server_name" {
  description = "The name of the MySQL server"
  value       = azurerm_mysql_flexible_server.main.name
}

output "mysql_fqdn" {
  description = "The FQDN of the MySQL server"
  value       = azurerm_mysql_flexible_server.main.fqdn
}

output "mysql_sku_name" {
  description = "The MySQL server SKU"
  value       = azurerm_mysql_flexible_server.main.sku_name
}

output "mysql_version" {
  description = "The MySQL server version"
  value       = azurerm_mysql_flexible_server.main.version
}

output "mysql_zone" {
  description = "The MySQL server availability zone"
  value       = azurerm_mysql_flexible_server.main.zone
}

output "mysql_private_endpoint_id" {
  description = "The MySQL private endpoint ID"
  value       = try(azurerm_private_endpoint.mysql[0].id, null)
}

output "mysql_private_endpoint_name" {
  description = "The MySQL private endpoint name"
  value       = try(azurerm_private_endpoint.mysql[0].name, null)
}

output "mysql_private_endpoint_ip" {
  description = "The MySQL private endpoint IP address"
  value = try(
    azurerm_private_endpoint.mysql[0].private_service_connection[0].private_ip_address,
    null
  )
}
