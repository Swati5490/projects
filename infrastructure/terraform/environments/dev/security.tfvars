# Development Security Configuration
# Key Vault
# Usage: terraform plan -var-file="environments/dev/_globals.tfvars" -var-file="environments/dev/security.tfvars"

# ============================================================================
# KEY VAULT - Development (Count: 1 vault)
# ============================================================================
key_vaults = {
  dev = {
    name                       = "kv-rewn-dev"
    sku                        = "standard"
    purge_protection_enabled   = false
    soft_delete_retention_days = 7
    enable_rbac_authorization  = true
  }
}

# ============================================================================
# MANAGED IDENTITIES - Development (Count: 1)
# ============================================================================
managed_identities = {
  aks = {
    name = "mi-aks-dev"
  }
}
