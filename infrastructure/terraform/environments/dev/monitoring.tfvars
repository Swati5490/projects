# Development Monitoring Configuration
# Log Analytics, Application Insights, and Action Groups
# Usage: terraform plan -var-file="environments/dev/_globals.tfvars" -var-file="environments/dev/monitoring.tfvars"

# ============================================================================
# MONITORING - Log Analytics Workspace
# ============================================================================
log_analytics_workspaces = {
  dev = {
    name                = "law-rewn-dev-cin"
    sku                 = "PerGB2018"
    retention_in_days   = 7
    daily_quota_gb      = 1
  }
}

# ============================================================================
# MONITORING - Application Insights
# ============================================================================
app_insights = {
  dev = {
    name              = "ai-rewn-dev-cin"
    application_type  = "web"
    retention_in_days = 7
  }
}

# ============================================================================
# MONITORING - Action Groups
# ============================================================================
action_groups = {
  dev = {
    name                = "ag-rewn-dev-cin"
    short_name          = "agdev"
    email_receiver_name = "Dev Team"
    email_address       = "dev@rewn.io"
  }
}

# ============================================================================
# MONITORING - Diagnostic Settings for MySQL
# ============================================================================
diagnostic_settings = {
  mysql_dev = {
    name                       = "diag-mysql-dev"
    target_resource_id         = "mysql-rewn-dev-cin"
    target_resource_type       = "mysql"
    log_analytics_workspace_id = "law-rewn-dev-cin"
    logs_enabled              = true
    metrics_enabled           = true
  }
}

# ============================================================================
# MONITORING - Alert Rules for MySQL
# ============================================================================
metric_alert_rules = {
  mysql_cpu_high = {
    name                = "alert-mysql-cpu-high-dev"
    resource_group      = "databases"
    scopes             = ["mysql-rewn-dev-cin"]
    metric_name        = "cpu_percent"
    operator           = "GreaterThan"
    threshold          = 75
    aggregation        = "Average"
    window_size        = "PT5M"
    frequency          = "PT1M"
    action_group       = "ag-mysql-dev"
  }
}
