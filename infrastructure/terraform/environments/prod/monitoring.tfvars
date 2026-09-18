# Production Monitoring Configuration
# Log Analytics, Application Insights, and Action Groups
# Usage: terraform plan -var-file="environments/prod/_globals.tfvars" -var-file="environments/prod/monitoring.tfvars"

# ============================================================================
# MONITORING - Log Analytics Workspace
# ============================================================================
log_analytics_workspaces = {
  primary = {
    name              = "law-rewn-prod"
    sku               = "PerGB2018"
    retention_in_days = 30
    daily_quota_gb    = 10
  }
}

# ============================================================================
# MONITORING - Application Insights
# ============================================================================
app_insights = {
  primary = {
    name              = "ai-rewn-prod"
    application_type  = "web"
    retention_in_days = 30
  }
}

# ============================================================================
# MONITORING - Action Groups
# ============================================================================
action_groups = {
  primary = {
    name                = "ag-rewn-prod"
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
    name                       = "diag-mysql"
    target_resource_id         = "mysql-rewn-prod"
    target_resource_type       = "mysql"
    log_analytics_workspace_id = "law-rewn-prod"
    logs_enabled               = true
    metrics_enabled            = true
  }
  cosmos_prod = {
    name                       = "diag-cosmos"
    target_resource_id         = "cosmos-mongo-rewn-prod"
    target_resource_type       = "cosmosdb"
    log_analytics_workspace_id = "law-rewn-prod"
    logs_enabled               = true
    metrics_enabled            = true
  }
  redis_prod = {
    name                       = "diag-redis"
    target_resource_id         = "redis-rewn-prod"
    target_resource_type       = "redis"
    log_analytics_workspace_id = "law-rewn-prod"
    logs_enabled               = true
    metrics_enabled            = true
  }
  appgw_prod = {
    name                       = "diag-appgw"
    target_resource_id         = "appgw-rewn"
    target_resource_type       = "application_gateway"
    log_analytics_workspace_id = "law-rewn-prod"
    logs_enabled               = true
    metrics_enabled            = true
  }
  aks_prod = {
    name                       = "diag-aks"
    target_resource_id         = "aks-rewn-prod"
    target_resource_type       = "aks"
    log_analytics_workspace_id = "law-rewn-prod"
    logs_enabled               = true
    metrics_enabled            = true
  }
  vm_all = {
    name                       = "diag-vm-all"
    target_resource_id         = "rg-compute-rewn-prod"
    target_resource_type       = "virtual_machine"
    log_analytics_workspace_id = "law-rewn-prod"
    logs_enabled               = true
    metrics_enabled            = true
  }
}

# ============================================================================
# MONITORING - Alert Rules for MySQL
# ============================================================================
metric_alert_rules = {
  mysql_cpu_high = {
    name           = "alert-mysql-cpu"
    resource_group = "databases"
    scopes         = ["mysql-rewn-prod"]
    metric_name    = "cpu_percent"
    operator       = "GreaterThan"
    threshold      = 80
    aggregation    = "Average"
    window_size    = "PT5M"
    frequency      = "PT1M"
    action_group   = "ag-mysql-prod"
  }
  mysql_storage_high = {
    name           = "alert-mysql-storage"
    resource_group = "databases"
    scopes         = ["mysql-rewn-prod"]
    metric_name    = "storage_percent"
    operator       = "GreaterThan"
    threshold      = 85
    aggregation    = "Average"
    window_size    = "PT5M"
    frequency      = "PT1M"
    action_group   = "ag-mysql-prod"
  }
  aks_cpu = {
    name           = "alert-aks-cpu"
    resource_group = "monitoring"
    scopes         = ["aks-rewn-prod"]
    metric_name    = "node_cpu_usage_percentage"
    operator       = "GreaterThan"
    threshold      = 80
    aggregation    = "Average"
    window_size    = "PT5M"
    frequency      = "PT1M"
    action_group   = "ag-rewn-prod"
  }
  aks_memory = {
    name           = "alert-aks-memory"
    resource_group = "monitoring"
    scopes         = ["aks-rewn-prod"]
    metric_name    = "node_memory_working_set_percentage"
    operator       = "GreaterThan"
    threshold      = 85
    aggregation    = "Average"
    window_size    = "PT5M"
    frequency      = "PT1M"
    action_group   = "ag-rewn-prod"
  }
}
