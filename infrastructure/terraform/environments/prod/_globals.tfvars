# Production Global Configuration
# Usage: Include this file first with -var-file="environments/prod/_globals.tfvars"

subscription_id = "YOUR_AZURE_SUBSCRIPTION_ID"
environment     = "prod"
project_name    = "rewn"
region          = "centralindia"
region_short    = "cin"

# Tags applied to all resources
tags = {
  ManagedBy      = "Terraform"
  Project        = "REWN"
  Environment    = "Production"
  CostCenter     = "engineering"
  Owner          = "infra-team@rewn.io"
  BackupRequired = "true"
  CreatedDate    = "2026-08-05"
}

cost_center = "engineering"
owner       = "infra-team@rewn.io"
