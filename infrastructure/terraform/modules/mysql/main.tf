# ============================================================================
# MYSQL FLEXIBLE SERVER
# ============================================================================

resource "azurerm_mysql_flexible_server" "main" {

  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location

  administrator_login    = var.administrator_login
  administrator_password = var.administrator_password

  sku_name = var.sku_name
  version  = var.mysql_version

  backup_retention_days        = var.backup_retention_days
  geo_redundant_backup_enabled = var.geo_redundant_backup_enabled

  zone = var.zone

  storage {
    size_gb           = var.storage_gb
    auto_grow_enabled = var.auto_grow_enabled
  }

  tags = merge(
    var.tags,
    {
      Environment = var.environment
      Project     = var.project_name
    }
  )
}


# ============================================================================
# MYSQL SERVER CONFIGURATIONS
# ============================================================================

resource "azurerm_mysql_flexible_server_configuration" "main" {

  for_each = var.configurations

  name                = each.value.name
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mysql_flexible_server.main.name
  value               = each.value.value
}


# ============================================================================
# PRIVATE ENDPOINT
# ============================================================================

resource "azurerm_private_endpoint" "mysql" {

  count = var.create_private_endpoint ? 1 : 0

  name                = var.private_endpoint_name
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = "${var.name}-private-connection"
    private_connection_resource_id = azurerm_mysql_flexible_server.main.id
    is_manual_connection           = false
    subresource_names              = var.private_endpoint_subresource_names
  }

  tags = merge(
    var.tags,
    {
      Environment = var.environment
      Project     = var.project_name
    }
  )
}