# Development Databases Configuration
# MySQL, Cosmos DB, and Redis
# Usage: terraform plan -var-file="environments/dev/_globals.tfvars" -var-file="environments/dev/databases.tfvars"

# ============================================================================
# DATABASES - MySQL (Count: 1 MySQL server)
# ============================================================================
mysql_servers = {
  dev = {
    name                          = "mysql-rewn-dev-cin"
    sku_name                      = "B_Standard_B1s"
    storage_gb                    = 20
    backup_retention_days         = 7
    geo_redundant_backup_enabled  = false
    zone                          = null
    auto_grow_enabled             = false
    administrator_login           = "mysqladmin"
    version                       = "8.0.21"
  }
}

# ============================================================================
# PRIVATE ENDPOINTS - MySQL (Count: 1)
# ============================================================================
private_endpoints = {
  mysql_dev = {
    name                = "pep-mysql-dev-cin"
    service_name        = "mysql-rewn-dev-cin"
    service_type        = "mysqlServer"
    subresource_names   = ["mysqlServer"]
    subnet_name         = "snet-db-dev-cin"
    resource_group      = "network"
  }
}

# ============================================================================
# KEY VAULT SECRETS - MySQL (Count: 2)
# ============================================================================
key_vault_secrets = {
  mysql_admin_password = {
    name        = "mysql-admin-password-dev"
    value       = "P@ssw0rd!Dev2024"
    key_vault   = "kv-rewn-dev-cin"
    content_type = "password"
  }
  mysql_connection_string = {
    name        = "mysql-connection-string-dev"
    value       = "Server=mysql-rewn-dev-cin.mysql.database.azure.com;Port=3306;Database=rewn_dev;Uid=mysqladmin;Pwd=P@ssw0rd!Dev2024;SslMode=Required;"
    key_vault   = "kv-rewn-dev-cin"
    content_type = "connection-string"
  }
}

# ============================================================================
# DATABASES - Cosmos DB (Count: 1 account)
# ============================================================================
cosmosdb_accounts = {
  mongo = {
    name                           = "cosmos-rewn-dev-cin"
    offer_type                     = "Standard"
    kind                           = "MongoDB"
    enable_automatic_failover      = false
    enable_multiple_write_locations = false
    consistency_level              = "Eventual"
  }
}

# ============================================================================
# DATABASES - Redis (Count: 1 cache)
# ============================================================================
redis_caches = {
  dev = {
    name              = "redis-rewn-dev-cin"
    capacity          = 0
    family            = "C"
    sku_name          = "Standard"
    enable_non_ssl    = false
    minimum_tls_version = "1.2"
    zones             = []
  }
}
