# Development Global Configuration
# Usage: Include this file first with -var-file="environments/dev/_globals.tfvars"

subscription_id = "YOUR_AZURE_SUBSCRIPTION_ID"
environment     = "dev"
project_name    = "rewn"
region          = "centralindia"
region_short    = "cin"

# Tags applied to all resources
tags = {
  ManagedBy      = "Terraform"
  Project        = "REWN"
  Environment    = "Development"
  CostCenter     = "engineering"
  Owner          = "dev-team@rewn.io"
  BackupRequired = "false"
  CreatedDate    = "2026-08-05"
}

cost_center = "engineering"
owner       = "dev-team@rewn.io"
