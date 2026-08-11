# Production Security Configuration
# Key Vault
# Usage: terraform plan -var-file="environments/prod/_globals.tfvars" -var-file="environments/prod/security.tfvars"

# ============================================================================
# KEY VAULT - Production (Count: 1 vault)
# ============================================================================
key_vaults = {
  primary = {
    name                            = "kv-rewn-prod-cin"
    sku                             = "standard"
    purge_protection_enabled        = true
    soft_delete_retention_days      = 90
    enable_rbac_authorization       = true
  }
}

# ============================================================================
# MANAGED IDENTITIES - Production (Count: 1)
# ============================================================================
managed_identities = {
  aks = {
    name = "mi-aks-prod"
  }
}
