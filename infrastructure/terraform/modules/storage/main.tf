# Storage Module - main.tf

# Storage Account
resource "azurerm_storage_account" "main" {
  count = var.storage_account_name != null ? 1 : 0

  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
  access_tier              = var.access_tier
  min_tls_version          = var.min_tls_version

  identity {
    type = "SystemAssigned"
  }

  tags = merge(
    var.tags,
    {
      Environment = var.environment
    }
  )
}

# Blob Container
resource "azurerm_storage_container" "main" {
  count = var.container_name != null ? 1 : 0

  name                  = var.container_name
  storage_account_name  = var.storage_account_name
  container_access_type = var.container_access_type

  depends_on = [azurerm_storage_account.main]
}

# Azure File Share
resource "azurerm_storage_share" "main" {
  count = var.share_name != null ? 1 : 0

  name                 = var.share_name
  storage_account_name = var.storage_account_name
  quota                = var.share_quota

  depends_on = [azurerm_storage_account.main]
}
