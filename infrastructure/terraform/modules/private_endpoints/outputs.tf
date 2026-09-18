output "id" {
  value = azurerm_private_endpoint.main.id
}

output "name" {
  value = azurerm_private_endpoint.main.name
}

output "private_ip_address" {
  value = try(
    azurerm_private_endpoint.main.private_service_connection[0].private_ip_address,
    null
  )
}