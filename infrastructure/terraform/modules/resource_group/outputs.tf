# Resource Group Module - outputs.tf

output "id" {
  description = "The ID of the created resource group"
  value       = azurerm_resource_group.main.id
}

output "name" {
  description = "The name of the created resource group"
  value       = azurerm_resource_group.main.name
}

output "location" {
  description = "The location of the created resource group"
  value       = azurerm_resource_group.main.location
}
