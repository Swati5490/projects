# Azure Functions Module - main.tf

# Data source to get storage account access key
data "azurerm_storage_account" "main" {
  count = var.function_app_name != null && var.function_name == null && var.storage_account_name != null && var.resource_group_name != null ? 1 : 0

  name                = var.storage_account_name
  resource_group_name = var.resource_group_name
}

# Function App (Container for functions)
resource "azurerm_service_plan" "functions" {
  count = var.function_app_name != null && var.function_name == null && var.resource_group_name != null && var.location != null ? 1 : 0

  name                = var.function_app_name
  location            = var.location
  resource_group_name = var.resource_group_name
  os_type             = "Linux"
  sku_name            = var.sku_name

  tags = merge(
    var.tags,
    {
      Environment = var.environment
    }
  )
}

# Function App
resource "azurerm_linux_function_app" "main" {
  count = var.function_app_name != null && var.function_name == null && var.resource_group_name != null && var.location != null ? 1 : 0

  name                = var.function_app_name
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = azurerm_service_plan.functions[0].id

  storage_account_name       = var.storage_account_name
  storage_account_access_key = try(data.azurerm_storage_account.main[0].primary_access_key, "")

  app_settings = merge(
    {
      "FUNCTIONS_WORKER_RUNTIME"       = var.runtime
      "WEBSITE_RUN_FROM_PACKAGE"       = "1"
      "AzureWebJobsFeatureFlags"       = "EnableWorkerIndexing"
    },
    var.app_settings
  )

  site_config {
    minimum_tls_version            = "1.2"
    http2_enabled                  = true
    application_insights_key       = var.application_insights_key
    application_insights_connection_string = var.application_insights_connection_string
    
    cors {
      allowed_origins = ["*"]
    }

    dynamic "ip_restriction" {
      for_each = var.ip_restrictions
      content {
        ip_address = ip_restriction.value
        priority   = index(var.ip_restrictions, ip_restriction.value) + 100
        action     = "Allow"
      }
    }
  }

  identity {
    type = "SystemAssigned"
  }

  tags = merge(
    var.tags,
    {
      Environment = var.environment
    }
  )

  depends_on = [azurerm_service_plan.functions]
}

# Data source to get existing function app (when function_app_id is provided)
# Note: This is used only for reference; actual function_app_id is passed as variable

# Function (Timer-triggered function)
resource "azurerm_function_app_function" "main" {
  count = var.function_name != null ? 1 : 0

  name            = var.function_name
  function_app_id = var.function_app_id
  language        = var.runtime
  test_data       = var.test_data

  config_json = jsonencode({
    scriptFile  = var.script_file
    bindings = [
      {
        type       = "timerTrigger"
        direction  = "in"
        name       = "Timer"
        schedule   = var.schedule
      },
      {
        type       = "queue"
        direction  = "out"
        name       = "outputQueue"
        queueName  = var.queue_name
        connection = "AzureWebJobsStorage"
      }
    ]
  })
}
