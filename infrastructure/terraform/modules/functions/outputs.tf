# Azure Functions Module - outputs.tf

output "function_app_id" {
  description = "The ID of the Function App"
  value       = try(azurerm_linux_function_app.main[0].id, null)
}

output "function_app_name" {
  description = "The name of the Function App"
  value       = try(azurerm_linux_function_app.main[0].name, null)
}

output "function_app_default_hostname" {
  description = "The default hostname of the Function App"
  value       = try(azurerm_linux_function_app.main[0].default_hostname, null)
}

output "service_plan_id" {
  description = "The ID of the App Service Plan"
  value       = try(azurerm_service_plan.functions[0].id, null)
}

output "principal_id" {
  description = "The principal ID of the managed identity"
  value       = try(azurerm_linux_function_app.main[0].identity[0].principal_id, null)
}

output "function_name" {
  description = "The name of the function"
  value       = try(azurerm_function_app_function.main[0].name, null)
}
