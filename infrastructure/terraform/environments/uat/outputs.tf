# ============================================================================
# RESOURCE GROUP OUTPUTS
# ============================================================================

output "resource_groups" {
  description = "Created Resource Groups"

  value = {
    for key, rg in module.resource_groups :
    key => {
      id       = rg.id
      name     = rg.name
      location = rg.location
    }
  }
}


# ============================================================================
# VNET OUTPUTS
# ============================================================================

output "vnet_ids" {
  description = "IDs of created VNets"

  value = module.networking.vnet_ids
}

output "vnet_names" {
  description = "Names of created VNets"

  value = module.networking.vnet_names
}

output "vnet_resource_group_names" {
  description = "Resource group names of created VNets"

  value = module.networking.vnet_resource_group_names
}


# ============================================================================
# SUBNET OUTPUTS
# ============================================================================

output "subnet_ids" {
  description = "IDs of created Subnets"

  value = module.networking.subnet_ids
}

output "subnet_names" {
  description = "Names of created Subnets"

  value = module.networking.subnet_names
}


# ============================================================================
# PRIVATE DNS ZONE OUTPUTS
# ============================================================================

output "private_dns_zone_ids" {
  description = "Private DNS Zone IDs"

  value = module.networking.private_dns_zone_ids
}

output "private_dns_zone_names" {
  description = "Private DNS Zone names"

  value = module.networking.private_dns_zone_names
}