# Monitoring Module - outputs.tf

output "workspace_id" {
  description = "Log Analytics Workspace ID"
  value       = azurerm_log_analytics_workspace.main.id
}

output "workspace_name" {
  description = "Log Analytics Workspace Name"
  value       = azurerm_log_analytics_workspace.main.name
}

output "workspace_resource_id" {
  description = "Log Analytics Workspace Resource ID"
  value       = azurerm_log_analytics_workspace.main.workspace_id
}

output "app_insights_id" {
  description = "Application Insights ID"
  value       = azurerm_application_insights.main.id
}

output "app_insights_instrumentation_key" {
  description = "Application Insights Instrumentation Key"
  value       = azurerm_application_insights.main.instrumentation_key
  sensitive   = true
}

output "action_group_id" {
  description = "Action Group ID"
  value       = azurerm_monitor_action_group.main.id
}
