output "application_gateway_ids" {
  description = "Application Gateway resource IDs"

  value = {
    for key, gateway in azurerm_application_gateway.main :
    key => gateway.id
  }
}


output "application_gateway_names" {
  description = "Application Gateway names"

  value = {
    for key, gateway in azurerm_application_gateway.main :
    key => gateway.name
  }
}


output "application_gateway_fqdns" {
  description = "Application Gateway frontend FQDNs"

  value = {
    for key, gateway in azurerm_application_gateway.main :
    key => gateway.frontend_ip_configuration[0].private_ip_address
  }
}


output "application_gateway_backend_address_pools" {
  description = "Application Gateway backend address pools"

  value = {
    for key, gateway in azurerm_application_gateway.main :
    key => gateway.backend_address_pool
  }
}


output "application_gateway_public_ip_ids" {
  description = "Public IP IDs associated with Application Gateway"

  value = {
    for key, gateway in var.application_gateways :
    key => gateway.public_ip_address_id
  }
}