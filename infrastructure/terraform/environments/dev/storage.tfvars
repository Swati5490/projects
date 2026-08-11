# Development Storage Configuration
# Storage Accounts and Blob Containers
# Usage: terraform plan -var-file="environments/dev/_globals.tfvars" -var-file="environments/dev/storage.tfvars"

# ============================================================================
# STORAGE ACCOUNTS - Development (Count: 1 account)
# ============================================================================
storage_accounts = {
  dev = {
    name                      = "strewndev001"
    account_tier              = "Standard"
    account_replication_type  = "LRS"
    access_tier               = "Hot"
    https_traffic_only_enabled = true
    min_tls_version           = "TLS1_2"
    blob_delete_retention     = 7
    versioning_enabled        = false
  }
}

# ============================================================================
# BLOB CONTAINERS - Development (Count: 3 containers)
# ============================================================================
blob_containers = {
  images = {
    name                  = "images"
    storage_account_name  = "strewndev001"
    container_access_type = "private"
  }
  deployments = {
    name                  = "deployments"
    storage_account_name  = "strewndev001"
    container_access_type = "private"
  }
  logs = {
    name                  = "logs"
    storage_account_name  = "strewndev001"
    container_access_type = "private"
  }
}

# ============================================================================
# AZURE FILE SHARES - Development (Count: 0 shares - placeholder for future use)
# ============================================================================
file_shares = {}
