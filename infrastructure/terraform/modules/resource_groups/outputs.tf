output "id" {
  description = "Resource Group ID"
  value       = azurerm_resource_group.main.id
}

output "name" {
  description = "Resource Group name"
  value       = azurerm_resource_group.main.name
}

output "location" {
  description = "Resource Group location"
  value       = azurerm_resource_group.main.location
}