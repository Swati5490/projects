# Production Databases Configuration
# MySQL, Cosmos DB, and Redis
# Usage: terraform plan -var-file="environments/prod/_globals.tfvars" -var-file="environments/prod/databases.tfvars"

# ============================================================================
# DATABASES - MySQL (Count: 1 MySQL server)
# ============================================================================
mysql_servers = {
  primary = {
    name                          = "mysql-rewn-prod-cin"
    sku_name                      = "B_Standard_B2s"
    storage_gb                    = 20
    backup_retention_days         = 35
    geo_redundant_backup_enabled  = true
    zone                          = "1"
    auto_grow_enabled             = true
    administrator_login           = "mysqladmin"
    version                       = "8.0.21"
  }
}

# ============================================================================
# PRIVATE ENDPOINTS - MySQL (Count: 1)
# ============================================================================
private_endpoints = {
  mysql_prod = {
    name                = "pep-mysql-prod-cin"
    service_name        = "mysql-rewn-prod-cin"
    service_type        = "mysqlServer"
    subresource_names   = ["mysqlServer"]
    subnet_name         = "snet-db-prod-cin"
    resource_group      = "network"
  }
}

# ============================================================================
# KEY VAULT SECRETS - MySQL (Count: 2)
# ============================================================================
key_vault_secrets = {
  mysql_admin_password = {
    name        = "mysql-admin-password"
    value       = "P@ssw0rd!2024REWN"
    key_vault   = "kv-rewn-prod-cin"
    content_type = "password"
  }
  mysql_connection_string = {
    name        = "mysql-connection-string"
    value       = "Server=mysql-rewn-prod-cin.mysql.database.azure.com;Port=3306;Database=rewn_prod;Uid=mysqladmin;Pwd=P@ssw0rd!2024REWN;SslMode=Required;"
    key_vault   = "kv-rewn-prod-cin"
    content_type = "connection-string"
  }
}

# ============================================================================
# DATABASES - Cosmos DB (Count: 1 account)
# ============================================================================
cosmosdb_accounts = {
  mongo = {
    name                           = "cosmos-rewn-prod-cin"
    offer_type                     = "Standard"
    kind                           = "MongoDB"
    enable_automatic_failover      = true
    enable_multiple_write_locations = false
    consistency_level              = "Session"
  }
}

# ============================================================================
# DATABASES - Redis (Count: 1 cache)
# ============================================================================
redis_caches = {
  primary = {
    name              = "redis-rewn-prod-cin"
    capacity          = 2
    family            = "P"
    sku_name          = "Premium"
    enable_non_ssl    = false
    minimum_tls_version = "1.2"
    zones             = ["1", "2"]
  }
}
