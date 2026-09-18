# ============================================================================
# DEVELOPMENT DATABASES CONFIGURATION
# ============================================================================

# ============================================================================
# DATABASES - MySQL
# ============================================================================

mysql_servers = {
  dev = {
    name                         = "mysql-rewn-dev"
    sku_name                     = "B_Standard_B1s"
    storage_gb                   = 20
    backup_retention_days        = 7
    geo_redundant_backup_enabled = false
    zone                         = null
    auto_grow_enabled            = false
    administrator_login          = "mysqladmin"
    version                      = "8.0.21"

    create = true
  }
}


# ============================================================================
# PRIVATE ENDPOINTS - MySQL
# ============================================================================

private_endpoints = {
  mysql_dev = {
    name              = "pep-mysql-dev"
    service_name      = "mysql-rewn-dev"
    service_type      = "mysqlServer"
    subresource_names = ["mysqlServer"]
    subnet_name       = "snet-db-dev"
    resource_group    = "network"

    create = true
  }
}


# ============================================================================
# KEY VAULT SECRETS
# ============================================================================

key_vault_secrets = {
  mysql_admin_password = {
    name         = "mysql-admin-password-dev"
    value        = "P@ssw0rd!Dev2024"
    key_vault    = "kv-rewn-dev"
    content_type = "password"

    create = true
  }

  mysql_connection_string = {
    name         = "mysql-connection-string-dev"
    value        = "Server=mysql-rewn-dev.mysql.database.azure.com;Port=3306;Database=rewn_dev;Uid=mysqladmin;Pwd=P@ssw0rd!Dev2024;SslMode=Required;"
    key_vault    = "kv-rewn-dev"
    content_type = "connection-string"

    create = true
  }
}


# ============================================================================
# DATABASES - Cosmos DB
# ============================================================================

cosmosdb_accounts = {
  mongo = {
    name                            = "cosmos-rewn-dev"
    offer_type                      = "Standard"
    kind                            = "MongoDB"
    enable_automatic_failover       = false
    enable_multiple_write_locations = false
    consistency_level               = "Eventual"

    create = true
  }
}


# ============================================================================
# DATABASES - Redis
# ============================================================================

redis_caches = {
  dev = {
    name                = "redis-rewn-dev"
    capacity            = 0
    family              = "C"
    sku_name            = "Standard"
    enable_non_ssl      = false
    minimum_tls_version = "1.2"
    zones               = []

    create = true
  }
}