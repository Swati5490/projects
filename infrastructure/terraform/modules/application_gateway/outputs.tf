output "appgw_id" {
  description = "Application Gateway ID"
  value       = try(azurerm_application_gateway.main[0].id, null)
}

output "appgw_name" {
  description = "Application Gateway name"
  value       = try(azurerm_application_gateway.main[0].name, null)
}

output "public_ip_id" {
  description = "Public IP ID"
  value       = try(azurerm_public_ip.appgw[0].id, null)
}

output "public_ip_address" {
  description = "Public IP address"
  value       = try(azurerm_public_ip.appgw[0].ip_address, null)
}

output "public_ip_fqdn" {
  description = "Public IP FQDN"
  value       = try(azurerm_public_ip.appgw[0].fqdn, null)
}

output "backend_address_pool_ids" {
  description = "Backend address pool IDs"
  value       = try({ for pool in azurerm_application_gateway.main[0].backend_address_pool : pool.name => pool.id }, {})
}

output "http_settings_ids" {
  description = "HTTP settings IDs"
  value       = try({ for settings in azurerm_application_gateway.main[0].backend_http_settings : settings.name => settings.id }, {})
}
