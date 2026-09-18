# ============================================================================
# KEY VAULT OUTPUTS
# ============================================================================

output "key_vault_id" {
  description = "ID of the Key Vault"
  value       = azurerm_key_vault.main.id
}

output "key_vault_name" {
  description = "Name of the Key Vault"
  value       = azurerm_key_vault.main.name
}

output "key_vault_uri" {
  description = "URI of the Key Vault"
  value       = azurerm_key_vault.main.vault_uri
}


# ============================================================================
# MANAGED IDENTITY OUTPUTS
# ============================================================================

output "managed_identity_ids" {
  description = "IDs of the User Assigned Managed Identities"
  value = {
    for key, identity in azurerm_user_assigned_identity.main :
    key => identity.id
  }
}

output "managed_identity_principal_ids" {
  description = "Principal IDs of the User Assigned Managed Identities"
  value = {
    for key, identity in azurerm_user_assigned_identity.main :
    key => identity.principal_id
  }
}

output "managed_identity_client_ids" {
  description = "Client IDs of the User Assigned Managed Identities"
  value = {
    for key, identity in azurerm_user_assigned_identity.main :
    key => identity.client_id
  }
}

output "managed_identity_names" {
  description = "Names of the User Assigned Managed Identities"
  value = {
    for key, identity in azurerm_user_assigned_identity.main :
    key => identity.name
  }
}


# ============================================================================
# FEDERATED IDENTITY CREDENTIAL OUTPUTS
# ============================================================================

output "federated_identity_credential_ids" {
  description = "IDs of Federated Identity Credentials"
  value = {
    for key, credential in azurerm_federated_identity_credential.main :
    key => credential.id
  }
}


# ============================================================================
# ROLE ASSIGNMENT OUTPUTS
# ============================================================================

output "role_assignment_ids" {
  description = "IDs of role assignments"
  value = {
    for key, assignment in azurerm_role_assignment.main :
    key => assignment.id
  }
}