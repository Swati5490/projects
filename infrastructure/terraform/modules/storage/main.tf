# ============================================================================
# STORAGE ACCOUNT
# ============================================================================

resource "azurerm_storage_account" "main" {

  count = (
    var.create_storage_account &&
    var.storage_account_name != null
  ) ? 1 : 0

  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
  access_tier              = var.access_tier

  https_traffic_only_enabled      = var.https_traffic_only_enabled
  public_network_access_enabled   = var.public_network_access_enabled
  allow_nested_items_to_be_public = var.allow_nested_items_to_be_public

  min_tls_version = var.min_tls_version

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


# ============================================================================
# BLOB CONTAINER
# ============================================================================

resource "azurerm_storage_container" "main" {

  count = (
    var.create_container &&
    var.container_name != null
  ) ? 1 : 0

  name                  = var.container_name
  storage_account_name  = var.storage_account_name
  container_access_type = var.container_access_type
}


# ============================================================================
# AZURE FILE SHARE
# ============================================================================

resource "azurerm_storage_share" "main" {

  count = (
    var.create_file_share &&
    var.share_name != null
  ) ? 1 : 0

  name                 = var.share_name
  storage_account_name = var.storage_account_name
  quota                = var.share_quota
}


# ============================================================================
# PRIVATE ENDPOINT
# ============================================================================

resource "azurerm_private_endpoint" "main" {

  count = (
    var.create_private_endpoint
  ) ? 1 : 0

  name                = var.private_endpoint_name
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {

    name = "${var.private_endpoint_name}-connection"

    private_connection_resource_id = (
      azurerm_storage_account.main[0].id
    )

    is_manual_connection = false

    subresource_names = var.private_endpoint_subresource_names
  }

  tags = merge(
    var.tags,
    {
      Environment = var.environment
    }
  )

  depends_on = [
    azurerm_storage_account.main
  ]
}


# ============================================================================
# CURRENT TERRAFORM / AZURE USER
# ============================================================================



# ============================================================================
# STORAGE BLOB DATA CONTRIBUTOR RBAC
# ============================================================================

data "azurerm_client_config" "current" {}

resource "azurerm_role_assignment" "blob_data_reader" {

  count = (
    var.create_storage_account &&
    var.assign_blob_data_reader
  ) ? 1 : 0

  scope                = azurerm_storage_account.main[0].id
  role_definition_name = "Storage Blob Data Reader"

  # Jis identity se Terraform run ho raha hai
  principal_id = data.azurerm_client_config.current.object_id
}