# Production Database Migration Service Configuration
# Azure Database Migration Service for RDS to MySQL migration
# Usage: terraform plan -var-file="environments/prod/_globals.tfvars" -var-file="environments/prod/migration.tfvars"

# ============================================================================
# DATABASE MIGRATION SERVICE - Production (Count: 1)
# ============================================================================
database_migration_services = {
  mysql_prod = {
    name         = "dms-rewn-prod"
    sku_name     = "Standard_1vCores"
    location     = "centralindia"
    virtual_network = "vnet-hub-rewn-prod-cin"
    subnet       = "snet-db-prod-cin"
  }
}

# ============================================================================
# MIGRATION PROJECTS - MySQL RDS to Azure (Count: 1)
# ============================================================================
migration_projects = {
  mysql_rds_prod = {
    name                  = "mig-mysql-prod"
    service_name          = "dms-rewn-prod"
    source_platform       = "MySQL"
    target_platform       = "AzureMySql"
    migration_type        = "OnlineMigration"
    source_connection_info = {
      server_name    = "production-whm8.xxxxxxxx.rds.amazonaws.com"
      user_name      = "admin"
      password       = "aws-rds-password"
      port           = 3306
      database_name  = "production_db"
    }
    target_connection_info = {
      server_name    = "mysql-rewn-prod-cin.mysql.database.azure.com"
      user_name      = "mysqladmin"
      password       = "P@ssw0rd!2024REWN"
      port           = 3306
      database_name  = "rewn_prod"
    }
  }
}