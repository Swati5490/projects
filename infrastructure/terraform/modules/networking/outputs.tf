# Networking Module - outputs.tf

output "vnet_id" {
  description = "The ID of the Virtual Network"
  value       = try(azurerm_virtual_network.main[0].id, null)
}

output "vnet_name" {
  description = "The name of the Virtual Network"
  value       = try(azurerm_virtual_network.main[0].name, null)
}

output "address_space" {
  description = "The address space of the Virtual Network"
  value       = try(azurerm_virtual_network.main[0].address_space, null)
}

output "subnet_id" {
  description = "The ID of the subnet"
  value       = try(azurerm_subnet.main[0].id, null)
}

output "nsg_id" {
  description = "The ID of the Network Security Group"
  value       = try(azurerm_network_security_group.main[0].id, null)
}

# ============================================================================
# NEW OUTPUTS - VNet Peering, Route Tables, NAT Gateways, Bastion, DNS Zones
# ============================================================================

output "vnet_peering_ids" {
  description = "IDs of VNet peerings"
  value       = { for k, v in azurerm_virtual_network_peering.main : k => v.id }
}

output "route_table_ids" {
  description = "IDs of route tables"
  value       = { for k, v in azurerm_route_table.main : k => v.id }
}

output "public_ip_ids" {
  description = "IDs of public IPs"
  value       = { for k, v in azurerm_public_ip.main : k => v.id }
}

output "public_ip_addresses" {
  description = "Public IP addresses"
  value       = { for k, v in azurerm_public_ip.main : k => v.ip_address }
}

output "nat_gateway_ids" {
  description = "IDs of NAT gateways"
  value       = { for k, v in azurerm_nat_gateway.main : k => v.id }
}

output "bastion_ids" {
  description = "IDs of Azure Bastion hosts"
  value       = { for k, v in azurerm_bastion_host.main : k => v.id }
}

output "private_dns_zone_ids" {
  description = "IDs of private DNS zones"
  value       = { for k, v in azurerm_private_dns_zone.main : k => v.id }
}
