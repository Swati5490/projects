# Production Storage Configuration
# Storage Accounts and Blob Containers
# Usage: terraform plan -var-file="environments/prod/_globals.tfvars" -var-file="environments/prod/storage.tfvars"

# ============================================================================
# STORAGE ACCOUNTS - Production (Count: 6 accounts)
# ============================================================================
storage_accounts = {
  general = {
    name                      = "strewnappprod001"
    account_tier              = "Standard"
    account_replication_type  = "GRS"
    access_tier               = "Hot"
    https_traffic_only_enabled = true
    min_tls_version           = "TLS1_2"
    blob_delete_retention     = 7
    versioning_enabled        = true
  }
  data = {
    name                      = "strewndataprod001"
    account_tier              = "Standard"
    account_replication_type  = "GRS"
    access_tier               = "Hot"
    https_traffic_only_enabled = true
    min_tls_version           = "TLS1_2"
    blob_delete_retention     = 7
    versioning_enabled        = true
  }
  backup = {
    name                      = "strewnbackupprod001"
    account_tier              = "Standard"
    account_replication_type  = "GRS"
    access_tier               = "Cool"
    https_traffic_only_enabled = true
    min_tls_version           = "TLS1_2"
    blob_delete_retention     = 30
    versioning_enabled        = true
  }
  static = {
    name                      = "strewnstaticprod001"
    account_tier              = "Standard"
    account_replication_type  = "GRS"
    access_tier               = "Hot"
    https_traffic_only_enabled = true
    min_tls_version           = "TLS1_2"
    blob_delete_retention     = 7
    versioning_enabled        = false
  }
  functions = {
    name                      = "stfuncrewnprod001"
    account_tier              = "Standard"
    account_replication_type  = "GRS"
    access_tier               = "Hot"
    https_traffic_only_enabled = true
    min_tls_version           = "TLS1_2"
    blob_delete_retention     = 7
    versioning_enabled        = true
  }
  migration = {
    name                      = "stmigrationrewnprod"
    account_tier              = "Standard"
    account_replication_type  = "GRS"
    access_tier               = "Cool"
    https_traffic_only_enabled = true
    min_tls_version           = "TLS1_2"
    blob_delete_retention     = 7
    versioning_enabled        = false
  }
  files = {
    name                      = "strewnfilesprod001"
    account_tier              = "Standard"
    account_replication_type  = "GRS"
    access_tier               = "Hot"
    https_traffic_only_enabled = true
    min_tls_version           = "TLS1_2"
    blob_delete_retention     = 7
    versioning_enabled        = false
  }
}

# ============================================================================
# BLOB CONTAINERS - Production (Count: 22 containers)
# ============================================================================
blob_containers = {
  # strewnappprod001 - Application Data (9 containers)
  rewn-authorizations = {
    name                  = "rewn-authorizations"
    storage_account_name  = "strewnappprod001"
    container_access_type = "private"
  }
  rewn-config = {
    name                  = "rewn-config"
    storage_account_name  = "strewnappprod001"
    container_access_type = "private"
  }
  rewn-data = {
    name                  = "rewn-data"
    storage_account_name  = "strewnappprod001"
    container_access_type = "private"
  }
  rewn-deployment = {
    name                  = "rewn-deployment"
    storage_account_name  = "strewnappprod001"
    container_access_type = "private"
  }
  dialer-user-files = {
    name                  = "dialer-user-files"
    storage_account_name  = "strewnappprod001"
    container_access_type = "private"
  }
  s3generalstorage = {
    name                  = "s3generalstorage"
    storage_account_name  = "strewnappprod001"
    container_access_type = "private"
  }
  s3userstorage = {
    name                  = "s3userstorage"
    storage_account_name  = "strewnappprod001"
    container_access_type = "private"
  }
  imdc-vacancy = {
    name                  = "imdc-vacancy"
    storage_account_name  = "strewnappprod001"
    container_access_type = "private"
  }
  rewn-scrapers-lambda = {
    name                  = "rewn-scrapers-lambda"
    storage_account_name  = "strewnappprod001"
    container_access_type = "private"
  }

  # strewndataprod001 - Business/Corelogic Data (6 containers)
  corelogic-deed = {
    name                  = "corelogic-deed"
    storage_account_name  = "strewndataprod001"
    container_access_type = "private"
  }
  corelogic-tax = {
    name                  = "corelogic-tax"
    storage_account_name  = "strewndataprod001"
    container_access_type = "private"
  }
  corelogic-hoamx = {
    name                  = "corelogic-hoamx"
    storage_account_name  = "strewndataprod001"
    container_access_type = "private"
  }
  corelogic-foreclosure = {
    name                  = "corelogic-foreclosure"
    storage_account_name  = "strewndataprod001"
    container_access_type = "private"
  }
  corelogic-involuntary = {
    name                  = "corelogic-involuntary"
    storage_account_name  = "strewndataprod001"
    container_access_type = "private"
  }
  source-data-archive = {
    name                  = "source-data-archive"
    storage_account_name  = "strewndataprod001"
    container_access_type = "private"
  }

  # strewnbackupprod001 - Backups (2 containers)
  realproprt-backups = {
    name                  = "realproprt-backups"
    storage_account_name  = "strewnbackupprod001"
    container_access_type = "private"
  }
  realproprt-backups-mirror = {
    name                  = "realproprt-backups-mirror"
    storage_account_name  = "strewnbackupprod001"
    container_access_type = "private"
  }

  # strewnstaticprod001 - Static Website/CDN (2 containers)
  rewn-cdn = {
    name                  = "rewn-cdn"
    storage_account_name  = "strewnstaticprod001"
    container_access_type = "blob"
  }
  rewn-realestatewealthnetwork-com = {
    name                  = "rewn-realestatewealthnetwork-com"
    storage_account_name  = "strewnstaticprod001"
    container_access_type = "blob"
  }

  # stfuncrewnprod001 - Functions (placeholder for future use)
  # stmigrationrewnprod - Migration (placeholder for future use)
}

# ============================================================================
# AZURE FILE SHARES - Production (Count: 4 shares)
# ============================================================================
file_shares = {
  production-efs = {
    name                  = "production-efs"
    storage_account_name  = "strewnfilesprod001"
    quota                 = 1044
  }
  user-efs = {
    name                  = "user-efs"
    storage_account_name  = "strewnfilesprod001"
    quota                 = 54
  }
  nginx-webroot = {
    name                  = "nginx-webroot"
    storage_account_name  = "strewnfilesprod001"
    quota                 = 6
  }
  application-share = {
    name                  = "application-share"
    storage_account_name  = "strewnfilesprod001"
    quota                 = 1
  }
}
