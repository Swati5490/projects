# ============================================================================
# KEY VAULT
# ============================================================================

resource "azurerm_key_vault" "main" {
  name                            = var.key_vault_name
  location                        = var.location
  resource_group_name             = var.resource_group_name
  tenant_id                       = var.tenant_id
  sku_name                        = var.sku_name
  purge_protection_enabled        = var.purge_protection_enabled
  soft_delete_retention_days      = var.soft_delete_retention_days
  enable_rbac_authorization       = var.enable_rbac_authorization
  enabled_for_deployment          = true
  enabled_for_disk_encryption     = true
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


# ============================================================================
# KEY VAULT SECRETS
# ============================================================================

resource "azurerm_key_vault_secret" "main" {
  for_each = nonsensitive(toset(keys(var.key_vault_secrets)))

  name         = var.key_vault_secrets[each.key].name
  value        = var.key_vault_secrets[each.key].value
  key_vault_id = azurerm_key_vault.main.id
  content_type = try(var.key_vault_secrets[each.key].content_type, null)
  tags         = try(var.key_vault_secrets[each.key].tags, {})
}


# ============================================================================
# USER ASSIGNED MANAGED IDENTITIES
# ============================================================================

resource "azurerm_user_assigned_identity" "main" {
  for_each = {
    for key, identity in var.managed_identities :
    key => identity if try(identity.create, true)
  }

  name                = each.value.name
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags
}


# ============================================================================
# FEDERATED IDENTITY CREDENTIALS
# ============================================================================

resource "azurerm_federated_identity_credential" "main" {
  for_each = {
    for key, credential in var.federated_credentials :
    key => credential if try(credential.create, true)
  }

  name                = each.value.name
  resource_group_name = var.resource_group_name

  parent_id = azurerm_user_assigned_identity.main[
    each.value.identity_key
  ].id

  audience = each.value.audience
  issuer   = each.value.issuer
  subject  = each.value.subject
}


# ============================================================================
# ROLE ASSIGNMENTS
# ============================================================================

resource "azurerm_role_assignment" "main" {
  for_each = var.role_assignments

  name                 = each.value.name
  scope                = each.value.scope
  role_definition_name = each.value.role_definition_name

  principal_id = azurerm_user_assigned_identity.main[
    each.value.identity_key
  ].principal_id
}