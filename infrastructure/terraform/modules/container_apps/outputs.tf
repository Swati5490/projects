output "id" {
  value = azurerm_container_app.main.id
}

output "name" {
  value = azurerm_container_app.main.name
}

output "latest_revision_name" {
  value = azurerm_container_app.main.latest_revision_name
}

output "latest_revision_fqdn" {
  value = azurerm_container_app.main.latest_revision_fqdn
}

output "outbound_ip_addresses" {
  value = azurerm_container_app.main.outbound_ip_addresses
}