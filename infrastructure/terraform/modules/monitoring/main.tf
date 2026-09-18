# Monitoring Module - main.tf

# Log Analytics Workspace
resource "azurerm_log_analytics_workspace" "main" {
  count               = length(var.log_analytics_workspaces) > 0 ? 1 : 0
  name                = values(var.log_analytics_workspaces)[0].name
  location            = var.region
  resource_group_name = var.resource_groups["monitoring"].name
  sku                 = try(values(var.log_analytics_workspaces)[0].sku, "PerGB2018")
  retention_in_days   = try(values(var.log_analytics_workspaces)[0].retention_in_days, 30)

  tags = merge(
    var.tags,
    {
      Environment = var.environment
    }
  )
}

# Application Insights
resource "azurerm_application_insights" "main" {
  count               = length(var.app_insights) > 0 ? 1 : 0
  name                = values(var.app_insights)[0].name
  location            = var.region
  resource_group_name = var.resource_groups["monitoring"].name
  application_type    = try(values(var.app_insights)[0].application_type, "web")
  workspace_id        = azurerm_log_analytics_workspace.main[0].id

  tags = merge(
    var.tags,
    {
      Environment = var.environment
    }
  )
}

# Action Group
resource "azurerm_monitor_action_group" "main" {
  count               = length(var.action_groups) > 0 ? 1 : 0
  name                = values(var.action_groups)[0].name
  resource_group_name = var.resource_groups["monitoring"].name
  short_name          = try(values(var.action_groups)[0].short_name, "rewnprod")

  email_receiver {
    name                    = try(values(var.action_groups)[0].email_receiver_name, "DevOps Team")
    email_address           = try(values(var.action_groups)[0].email_address, "devops@rewn.io")
    use_common_alert_schema = true
  }

  tags = merge(
    var.tags,
    {
      Environment = var.environment
    }
  )
}

resource "azurerm_monitor_diagnostic_setting" "main" {
  for_each = var.diagnostic_settings

  name                       = each.value.name
  target_resource_id         = each.value.target_resource_id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main[0].id

  enabled_log {
    category = "AllLogs"
  }

  metric {
    category = "AllMetrics"
    enabled  = try(each.value.metrics_enabled, true)
  }
}

resource "azurerm_monitor_metric_alert" "main" {
  for_each = var.metric_alert_rules

  name                = each.value.name
  resource_group_name = var.resource_groups["monitoring"].name
  scopes              = each.value.scopes
  description         = "Metric alert for ${each.value.metric_name}"
  severity            = 2
  frequency           = each.value.frequency
  window_size         = each.value.window_size

  criteria {
    metric_name      = each.value.metric_name
    metric_namespace = try(each.value.metric_namespace, "Microsoft.ContainerService/managedClusters")
    operator         = each.value.operator
    threshold        = each.value.threshold
    aggregation      = each.value.aggregation
  }

  action {
    action_group_id = azurerm_monitor_action_group.main[0].id
  }
}
