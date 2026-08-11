# Production Monitoring Configuration
# Log Analytics, Application Insights, and Action Groups
# Usage: terraform plan -var-file="environments/prod/_globals.tfvars" -var-file="environments/prod/monitoring.tfvars"

# ============================================================================
# MONITORING - Log Analytics Workspace
# ============================================================================
log_analytics_workspaces = {
  primary = {
    name                = "law-rewn-prod-cin"
    sku                 = "PerGB2018"
    retention_in_days   = 30
    daily_quota_gb      = 10
  }
}

# ============================================================================
# MONITORING - Application Insights
# ============================================================================
app_insights = {
  primary = {
    name              = "ai-rewn-prod-cin"
    application_type  = "web"
    retention_in_days = 30
  }
}

# ============================================================================
# MONITORING - Action Groups
# ============================================================================
action_groups = {
  primary = {
    name                = "ag-rewn-prod-cin"
    short_name          = "agcrit"
    email_receiver_name = "DevOps Team"
    email_address       = "devops@rewn.io"
  }
}

# ============================================================================
# MONITORING - Diagnostic Settings for MySQL
# ============================================================================
diagnostic_settings = {
  mysql_prod = {
    name                       = "diag-mysql-prod"
    target_resource_id         = "mysql-rewn-prod-cin"
    target_resource_type       = "mysql"
    log_analytics_workspace_id = "law-rewn-prod-cin"
    logs_enabled              = true
    metrics_enabled           = true
  }
}

# ============================================================================
# MONITORING - Alert Rules for MySQL
# ============================================================================
metric_alert_rules = {
  mysql_cpu_high = {
    name                = "alert-mysql-cpu-high"
    resource_group      = "databases"
    scopes             = ["mysql-rewn-prod-cin"]
    metric_name        = "cpu_percent"
    operator           = "GreaterThan"
    threshold          = 80
    aggregation        = "Average"
    window_size        = "PT5M"
    frequency          = "PT1M"
    action_group       = "ag-mysql-prod"
  }
  mysql_storage_high = {
    name                = "alert-mysql-storage-high"
    resource_group      = "databases"
    scopes             = ["mysql-rewn-prod-cin"]
    metric_name        = "storage_percent"
    operator           = "GreaterThan"
    threshold          = 85
    aggregation        = "Average"
    window_size        = "PT5M"
    frequency          = "PT1M"
    action_group       = "ag-mysql-prod"
  }
}
