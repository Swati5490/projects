# Development Backup Configuration
# Recovery Services Vault and Backup Policies
# Usage: terraform plan -var-file="environments/dev/_globals.tfvars" -var-file="environments/dev/backup.tfvars"

# ============================================================================
# BACKUP - Recovery Services Vault
# ============================================================================
recovery_services_vaults = {
  dev = {
    name                           = "rsv-rewn-dev-cin"
    sku                            = "Standard"
    storage_mode_type              = "LocallyRedundant"
  }
}

# ============================================================================
# BACKUP - Backup Policies
# ============================================================================
backup_policies = {
  daily_backup = {
    name                = "backup-policy-rewn-dev-cin"
    backup_frequency    = "Daily"
    backup_time         = "02:00"
    retention_daily     = 7
    retention_weekly    = 4
    retention_monthly   = 0
    retention_yearly    = 0
  }
}
