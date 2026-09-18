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
# HUB VNET OUTPUTS
# ============================================================================

output "hub_vnet_id" {
  description = "Hub VNet ID"

  value = module.networking.vnet_ids["vnet_hub"]
}

output "hub_vnet_name" {
  description = "Hub VNet name"

  value = module.networking.vnet_names["vnet_hub"]
}

output "hub_resource_group_name" {
  description = "Hub VNet Resource Group name"

  value = module.networking.vnet_resource_group_names["vnet_hub"]
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