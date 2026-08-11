# Azure Functions Module - variables.tf

variable "function_app_name" {
  description = "Name of the Function App"
  type        = string
  default     = null
}

variable "function_app_id" {
  description = "ID of an existing Function App (for attaching functions)"
  type        = string
  default     = null
}

variable "function_name" {
  description = "Name of the individual function"
  type        = string
  default     = null
}

variable "location" {
  description = "Azure location"
  type        = string
  default     = null
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = null
}

variable "sku_name" {
  description = "SKU name for App Service Plan (e.g., Y1, EP1, EP2)"
  type        = string
  default     = "Y1"
}

variable "runtime" {
  description = "Function runtime (python, node, powershell, dotnet)"
  type        = string
  default     = "python"
}

variable "storage_account_name" {
  description = "Storage account name for function app"
  type        = string
  default     = null
}

variable "app_settings" {
  description = "Additional app settings for function app"
  type        = map(string)
  default     = {}
}

variable "application_insights_key" {
  description = "Application Insights instrumentation key"
  type        = string
  default     = null
}

variable "application_insights_connection_string" {
  description = "Application Insights connection string"
  type        = string
  default     = null
}

variable "script_file" {
  description = "Path to the main script file"
  type        = string
  default     = "main.py"
}

variable "schedule" {
  description = "Timer schedule expression (CRON format)"
  type        = string
  default     = "0 0 * * * *"
}

variable "queue_name" {
  description = "Output queue name for function"
  type        = string
  default     = ""
}

variable "test_data" {
  description = "Test data for function testing"
  type        = string
  default     = "{}"
}

variable "ip_restrictions" {
  description = "IP restrictions for function app"
  type        = list(string)
  default     = []
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "project_name" {
  description = "Project name"
  type        = string
}

variable "tags" {
  description = "Tags to apply"
  type        = map(string)
  default     = {}
}
