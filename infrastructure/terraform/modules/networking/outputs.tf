# ============================================================================
# VNET OUTPUTS
# ============================================================================

output "vnet_ids" {
  description = "IDs of created VNets"

  value = {
    for key, vnet in azurerm_virtual_network.main :
    key => vnet.id
  }
}

output "vnet_names" {
  description = "Names of created VNets"

  value = {
    for key, vnet in azurerm_virtual_network.main :
    key => vnet.name
  }
}

output "vnet_resource_group_names" {
  description = "Resource group names of VNets"

  value = {
    for key, vnet in azurerm_virtual_network.main :
    key => vnet.resource_group_name
  }
}


# ============================================================================
# PRIVATE DNS ZONE OUTPUTS
# ============================================================================

output "private_dns_zone_ids" {
  description = "IDs of created Private DNS Zones"

  value = {
    for key, zone in azurerm_private_dns_zone.main :
    key => zone.id
  }
}

output "private_dns_zone_names" {
  description = "Names of created Private DNS Zones"

  value = {
    for key, zone in azurerm_private_dns_zone.main :
    key => zone.name
  }
}

# ============================================================================
# SUBNET OUTPUTS
# ============================================================================

output "subnet_ids" {
  description = "IDs of created Subnets"

  value = {
    for key, subnet in azurerm_subnet.main :
    key => subnet.id
  }
}

output "subnet_names" {
  description = "Names of created Subnets"

  value = {
    for key, subnet in azurerm_subnet.main :
    key => subnet.name
  }
}

output "public_ip_ids" {
  description = "IDs of created public IPs"

  value = {
    for key, public_ip in azurerm_public_ip.main :
    key => public_ip.id
  }
}