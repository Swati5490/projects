# ============================================================================
# KEY VAULT - Production
# ============================================================================

key_vaults = {
  primary = {
    name                       = "kv-rewn-prod-6789"
    sku                        = "standard"
    purge_protection_enabled   = true
    soft_delete_retention_days = 90
    enable_rbac_authorization  = true
    create                     = true
  }
}

# ============================================================================
# MANAGED IDENTITIES - Production
# ============================================================================

managed_identities = {

  # Shared identity for multiple VMs accessing Blob Storage
  storage = {
    name   = "mi-storage-prod"
    create = true
  }

  # Identity for Azure Container Apps accessing application resources / Key Vault
  container_apps = {
    name   = "mi-container-apps-prod"
    create = true
  }
}


# ============================================================================
# FEDERATED IDENTITY CREDENTIALS
# ============================================================================

federated_identity_credentials = {}

# ============================================================================
# ROLE ASSIGNMENTS
# ============================================================================

role_assignments = {}