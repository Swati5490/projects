# Security Module - main.tf

resource "azurerm_key_vault" "main" {
  name                        = var.key_vault_name
  location                    = var.location
  resource_group_name         = var.resource_group_name
  tenant_id                   = var.tenant_id
  sku_name                    = var.sku_name
  purge_protection_enabled    = var.purge_protection_enabled
  soft_delete_retention_days  = var.soft_delete_retention_days
  enable_rbac_authorization   = var.enable_rbac_authorization
  enabled_for_deployment      = true
  enabled_for_disk_encryption = true
  enabled_for_template_deployment = true

  network_acls {
    default_action = "Allow"
    bypass         = "AzureServices"
  }

  tags = merge(
    var.tags,
    {
      Environment = var.environment
    }
  )
}
