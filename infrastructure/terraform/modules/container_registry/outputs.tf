# Azure Container Registry Module - outputs.tf

output "registry_id" {
  description = "The ID of the container registry"
  value       = try(azurerm_container_registry.main[0].id, null)
}

output "registry_name" {
  description = "The name of the container registry"
  value       = try(azurerm_container_registry.main[0].name, null)
}

output "login_server" {
  description = "The URL that can be used to log into the container registry"
  value       = try(azurerm_container_registry.main[0].login_server, null)
}

output "admin_username" {
  description = "The Username associated with the Container Registry Admin account"
  value       = try(azurerm_container_registry.main[0].admin_username, null)
  sensitive   = true
}

output "admin_password" {
  description = "The Password associated with the Container Registry Admin account"
  value       = try(azurerm_container_registry.main[0].admin_password, null)
  sensitive   = true
}

output "identity_principal_id" {
  description = "The principal ID of the system-assigned managed identity"
  value       = try(azurerm_container_registry.main[0].identity[0].principal_id, null)
}

output "identity_tenant_id" {
  description = "The tenant ID of the system-assigned managed identity"
  value       = try(azurerm_container_registry.main[0].identity[0].tenant_id, null)
}

output "webhooks" {
  description = "Map of webhook names to webhook information"
  value = {
    for k, v in azurerm_container_registry_webhook.main : k => {
      id   = v.id
      name = v.name
    }
  }
}
