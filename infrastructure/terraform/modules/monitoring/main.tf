# Monitoring Module - main.tf

# Log Analytics Workspace
resource "azurerm_log_analytics_workspace" "main" {
  name                = "law-${var.project_name}-${var.environment}-${lower(var.region)}"
  location            = var.region
  resource_group_name = var.resource_groups["monitoring"].name
  sku                 = "PerGB2018"
  retention_in_days   = 30

  tags = merge(
    var.tags,
    {
      Environment = var.environment
    }
  )
}

# Application Insights
resource "azurerm_application_insights" "main" {
  name                = "appi-${var.project_name}-${var.environment}-${lower(var.region)}"
  location            = var.region
  resource_group_name = var.resource_groups["monitoring"].name
  application_type    = "web"
  workspace_id        = azurerm_log_analytics_workspace.main.id

  tags = merge(
    var.tags,
    {
      Environment = var.environment
    }
  )
}

# Action Group
resource "azurerm_monitor_action_group" "main" {
  name                = "ag-${var.project_name}-${var.environment}"
  resource_group_name = var.resource_groups["monitoring"].name
  short_name          = "${var.project_name}${var.environment}"

  email_receiver {
    name           = "SendToAdmin"
    email_address  = "admin@rewn.io"
    use_common_alert_schema = true
  }

  tags = merge(
    var.tags,
    {
      Environment = var.environment
    }
  )
}
