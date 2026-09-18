mysql_servers = {
  primary = {
    name               = "mysql-rewn-prod"
    resource_group_key = "rg_databases"

    sku_name   = "B_Standard_B2s"
    version    = "8.0.21"
    storage_gb = 20
    zone       = "1"

    backup_retention_days        = 35
    geo_redundant_backup_enabled = true

    auto_grow_enabled = true

    administrator_login = "mysqladmin"

    configurations = {
      mysql_config = {
        name  = "mysql-config"
        value = "ON"
      }
    }

    private_endpoint = {
      name              = "pep-mysql-prod"
      subresource_names = ["mysqlServer"]
      subnet_key        = "snet_pe"
    }

    create = true
  }
}