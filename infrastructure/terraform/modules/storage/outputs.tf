# Storage Module - outputs.tf

output "storage_account_id" {
  description = "The ID of the storage account"
  value       = try(azurerm_storage_account.main[0].id, null)
}

output "storage_account_name" {
  description = "The name of the storage account"
  value       = try(azurerm_storage_account.main[0].name, null)
}

output "primary_blob_endpoint" {
  description = "The primary blob endpoint"
  value       = try(azurerm_storage_account.main[0].primary_blob_endpoint, null)
}

output "container_id" {
  description = "The ID of the blob container"
  value       = try(azurerm_storage_container.main[0].id, null)
}

output "container_name" {
  description = "The name of the blob container"
  value       = try(azurerm_storage_container.main[0].name, null)
}

output "file_share_name" {
  description = "The name of the Azure file share"
  value       = try(azurerm_storage_share.main[0].name, null)
}

output "file_share_quota" {
  description = "The quota of the Azure file share in GB"
  value       = try(azurerm_storage_share.main[0].quota, null)
}

output "file_share_storage_account_name" {
  description = "The storage account name for the file share"
  value       = var.storage_account_name
}

output "storage_account_key" {
  description = "The primary storage account access key"
  value       = try(azurerm_storage_account.main[0].primary_access_key, "")
  sensitive   = true
}
