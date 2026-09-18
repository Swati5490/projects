# Monitoring Module - outputs.tf

output "workspace_id" {
  description = "Log Analytics Workspace ID"
  value       = try(azurerm_log_analytics_workspace.main[0].id, null)
}

output "workspace_name" {
  description = "Log Analytics Workspace Name"
  value       = try(azurerm_log_analytics_workspace.main[0].name, null)
}

output "workspace_resource_id" {
  description = "Log Analytics Workspace Resource ID"
  value       = try(azurerm_log_analytics_workspace.main[0].workspace_id, null)
}

output "app_insights_id" {
  description = "Application Insights ID"
  value       = try(azurerm_application_insights.main[0].id, null)
}

output "app_insights_instrumentation_key" {
  description = "Application Insights Instrumentation Key"
  value       = try(azurerm_application_insights.main[0].instrumentation_key, null)
  sensitive   = true
}

output "action_group_id" {
  description = "Action Group ID"
  value       = try(azurerm_monitor_action_group.main[0].id, null)
}
