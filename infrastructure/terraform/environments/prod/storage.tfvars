# ============================================================================
# STORAGE ACCOUNTS - Production
# ============================================================================

storage_accounts = {

  # ==========================================================================
  # APPLICATION / GENERAL STORAGE
  # ==========================================================================

  general = {
    name               = "strewnappprod6789"
    resource_group_key = "rg_storage"

    account_tier             = "Standard"
    account_replication_type = "LRS"
    access_tier              = "Hot"

    https_traffic_only_enabled      = true
    public_network_access_enabled   = true
    allow_nested_items_to_be_public = false

    min_tls_version       = "TLS1_2"
    blob_delete_retention = 7
    versioning_enabled    = true

    assign_blob_data_reader = true

    private_endpoint = {
      name              = "pep-storage-app"
      subresource_names = ["blob"]
      subnet_key        = "snet_pe"
    }

    create = true
  }


  # ==========================================================================
  # DATA STORAGE
  # ==========================================================================

  data = {
    name               = "strewndataprod6789"
    resource_group_key = "rg_storage"

    account_tier             = "Standard"
    account_replication_type = "LRS"
    access_tier              = "Hot"

    https_traffic_only_enabled      = true
    public_network_access_enabled   = true
    allow_nested_items_to_be_public = false

    min_tls_version       = "TLS1_2"
    blob_delete_retention = 7
    versioning_enabled    = true

    assign_blob_data_reader = true

    private_endpoint = {
      name              = "pep-storage-data"
      subresource_names = ["blob"]
      subnet_key        = "snet_pe"
    }

    create = true
  }


  # ==========================================================================
  # BACKUP STORAGE
  # ==========================================================================

  backup = {
    name               = "strewnbackupprod6789"
    resource_group_key = "rg_storage"

    account_tier             = "Standard"
    account_replication_type = "LRS"
    access_tier              = "Cool"

    https_traffic_only_enabled      = true
    public_network_access_enabled   = true
    allow_nested_items_to_be_public = false

    min_tls_version       = "TLS1_2"
    blob_delete_retention = 30
    versioning_enabled    = true

    assign_blob_data_reader = true

    private_endpoint = {
      name              = "pep-storage-backup"
      subresource_names = ["blob"]
      subnet_key        = "snet_pe"
    }

    create = true
  }


  # ==========================================================================
  # LOGS STORAGE
  # ==========================================================================

  logs = {
    name               = "strewnlogsprod6789"
    resource_group_key = "rg_storage"

    account_tier             = "Standard"
    account_replication_type = "LRS"
    access_tier              = "Hot"

    https_traffic_only_enabled      = true
    public_network_access_enabled   = true
    allow_nested_items_to_be_public = false

    min_tls_version       = "TLS1_2"
    blob_delete_retention = 30
    versioning_enabled    = true

    assign_blob_data_reader = true

    private_endpoint = {
      name              = "pep-storage-logs"
      subresource_names = ["blob"]
      subnet_key        = "snet_pe"
    }

    create = true
  }


  # ==========================================================================
  # FUTURE STORAGE ACCOUNTS
  # ==========================================================================

  static = {
    name               = "strewnstaticprod6789"
    resource_group_key = "rg_storage"

    account_tier             = "Standard"
    account_replication_type = "LRS"
    access_tier              = "Hot"

    https_traffic_only_enabled      = true
    public_network_access_enabled   = true
    allow_nested_items_to_be_public = false

    min_tls_version       = "TLS1_2"
    blob_delete_retention = 7
    versioning_enabled    = false

    create = true
  }


  functions = {
    name               = "stfuncrewnprod6789"
    resource_group_key = "rg_storage"

    account_tier             = "Standard"
    account_replication_type = "LRS"
    access_tier              = "Hot"

    https_traffic_only_enabled      = true
    public_network_access_enabled   = true
    allow_nested_items_to_be_public = false

    min_tls_version       = "TLS1_2"
    blob_delete_retention = 7
    versioning_enabled    = true

    create = true
  }


  migration = {
    name               = "stmigrationrewnprod6789"
    resource_group_key = "rg_storage"

    account_tier             = "Standard"
    account_replication_type = "LRS"
    access_tier              = "Cool"

    https_traffic_only_enabled      = true
    public_network_access_enabled   = true
    allow_nested_items_to_be_public = false

    min_tls_version       = "TLS1_2"
    blob_delete_retention = 7
    versioning_enabled    = false

    create = true
  }


  files = {
    name               = "strewnfilesprod6789"
    resource_group_key = "rg_storage"

    account_tier             = "Standard"
    account_replication_type = "LRS"
    access_tier              = "Hot"

    https_traffic_only_enabled      = true
    public_network_access_enabled   = true
    allow_nested_items_to_be_public = false

    min_tls_version       = "TLS1_2"
    blob_delete_retention = 7
    versioning_enabled    = false

    create = true
  }
}


# ============================================================================
# BLOB CONTAINERS - Production
# ============================================================================

blob_containers = {

  # ==========================================================================
  # APPLICATION STORAGE → strewnappprod12345
  # ==========================================================================

  rewn-cdn = {
    name                  = "rewn-cdn"
    storage_account_key   = "general"
    container_access_type = "private"
    create                = true
  }

  rewn-config = {
    name                  = "rewn-config"
    storage_account_key   = "general"
    container_access_type = "private"
    create                = true
  }

  plm-private-documents-770526846351-us-east-1-an = {
    name                  = "plm-private-documents-770526846351-us-east-1-an"
    storage_account_key   = "general"
    container_access_type = "private"
    create                = true
  }

  s3generalstorage = {
    name                  = "s3generalstorage"
    storage_account_key   = "general"
    container_access_type = "private"
    create                = true
  }

  imdc-vacancy = {
    name                  = "imdc-vacancy"
    storage_account_key   = "general"
    container_access_type = "private"
    create                = true
  }

  # ==========================================================================
  # DATA STORAGE → strewndataprod12345
  # ==========================================================================

  rewn-data = {
    name                  = "rewn-data"
    storage_account_key   = "data"
    container_access_type = "private"
    create                = true
  }

  corelogic-deed = {
    name                  = "corelogic-deed"
    storage_account_key   = "data"
    container_access_type = "private"
    create                = true
  }

  corelogic-tax = {
    name                  = "corelogic-tax"
    storage_account_key   = "data"
    container_access_type = "private"
    create                = true
  }

  corelogic-hoamx = {
    name                  = "corelogic-hoamx"
    storage_account_key   = "data"
    container_access_type = "private"
    create                = true
  }

  corelogic-foreclosure = {
    name                  = "corelogic-foreclosure"
    storage_account_key   = "data"
    container_access_type = "private"
    create                = true
  }

  corelogic-involuntary = {
    name                  = "corelogic-involuntary"
    storage_account_key   = "data"
    container_access_type = "private"
    create                = true
  }

  source-data-archive = {
    name                  = "source-data-archive"
    storage_account_key   = "data"
    container_access_type = "private"
    create                = true
  }


  # ==========================================================================
  # BACKUP STORAGE → strewnbackupprod12345
  # ==========================================================================

  realproprt-backups = {
    name                  = "realproprt-backups"
    storage_account_key   = "backup"
    container_access_type = "private"
    create                = true
  }

  realproprt-backups-mirror = {
    name                  = "realproprt-backups-mirror"
    storage_account_key   = "backup"
    container_access_type = "private"
    create                = true
  }


  # ==========================================================================
  # LOG STORAGE → strewnlogsprod
  # ==========================================================================

  rewn-logs = {
    name                  = "rewn-logs"
    storage_account_key   = "logs"
    container_access_type = "private"
    create                = true
  }


  # ==========================================================================
  # FUTURE STATIC STORAGE
  # ==========================================================================

  rewn-realestatewealthnetwork-com = {
    name                  = "rewn-realestatewealthnetwork-com"
    storage_account_key   = "static"
    container_access_type = "private"
    create                = true
  }
}


# ============================================================================
# AZURE FILE SHARES - Production
# ============================================================================

file_shares = {

  production-efs = {
    name                = "production-efs"
    storage_account_key = "files"
    quota               = 1044
    create              = true
  }

  user-efs = {
    name                = "user-efs"
    storage_account_key = "files"
    quota               = 54
    create              = true
  }

  nginx-webroot = {
    name                = "nginx-webroot"
    storage_account_key = "files"
    quota               = 6
    create              = true
  }

  application-share = {
    name                = "application-share"
    storage_account_key = "files"
    quota               = 1
    create              = true
  }
}