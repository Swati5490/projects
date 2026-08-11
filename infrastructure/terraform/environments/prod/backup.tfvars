# Production Backup Configuration
# Recovery Services Vault and Backup Policies
# Usage: terraform plan -var-file="environments/prod/_globals.tfvars" -var-file="environments/prod/backup.tfvars"

# ============================================================================
# BACKUP - Recovery Services Vault
# ============================================================================
recovery_services_vaults = {
  primary = {
    name                           = "rsv-rewn-prod-cin"
    sku                            = "Standard"
    storage_mode_type              = "GeoRedundant"
  }
}

# ============================================================================
# BACKUP - Backup Policies
# ============================================================================
backup_policies = {
  daily_backup = {
    name                = "backup-policy-rewn-prod-cin"
    backup_frequency    = "Daily"
    backup_time         = "02:00"
    retention_daily     = 30
    retention_weekly    = 12
    retention_monthly   = 12
    retention_yearly    = 7
  }
}
