# Backup Module - outputs.tf

output "vault_id" {
  description = "Recovery Services Vault ID"
  value       = azurerm_recovery_services_vault.main.id
}

output "vault_name" {
  description = "Recovery Services Vault Name"
  value       = azurerm_recovery_services_vault.main.name
}

output "backup_policy_id" {
  description = "Backup Policy ID"
  value       = azurerm_backup_policy_vm.main.id
}
