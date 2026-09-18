# ============================================================================
# RESOURCE GROUPS
# ============================================================================

module "resource_groups" {
  source = "../../modules/resource_group"

  for_each = {
    for key, rg in var.resource_groups :
    key => rg
    if rg.create
  }

  resource_group_name = each.value.name

  region       = var.region
  environment  = var.environment
  project_name = var.project_name
  tags         = var.tags
}


# ============================================================================
# NETWORKING MODULE
# ============================================================================

module "networking" {

  source = "../../modules/networking"

  region       = var.region
  environment  = var.environment
  project_name = var.project_name
  tags         = var.tags

  # ==========================================================================
  # VIRTUAL NETWORKS
  # ==========================================================================

  vnets = {
    for key, vnet in var.vnets :
    key => {

      name = vnet.name

      resource_group_name = module.resource_groups[
        vnet.resource_group_key
      ].name

      address_space = vnet.address_space
      role          = vnet.role
      dns_servers   = vnet.dns_servers
      create        = vnet.create
    }
  }


  # ==========================================================================
  # SUBNETS
  # ==========================================================================

  subnets = {
    for key, subnet in var.subnets :
    key => {

      name = subnet.name

      resource_group_name = module.resource_groups[
        subnet.resource_group_key
      ].name

      vnet_name = var.vnets[
        subnet.vnet_key
      ].name

      address_prefixes = subnet.address_prefixes

      service_endpoints = subnet.service_endpoints

      private_endpoint_network_policies = (
        subnet.private_endpoint_network_policies
      )

      create = subnet.create
    }
  }


  # ==========================================================================
  # NETWORK SECURITY GROUPS
  # ==========================================================================

  network_security_groups = {
    for key, nsg in var.network_security_groups :
    key => {

      name = nsg.name

      resource_group_name = module.resource_groups[
        nsg.resource_group_key
      ].name

      create = nsg.create
    }
  }

  nsg_subnet_associations = var.nsg_subnet_associations


  # ==========================================================================
  # ROUTE TABLES
  # ==========================================================================

  route_tables = {
    for key, route_table in var.route_tables :
    key => {

      name = route_table.name

      resource_group_name = module.resource_groups[
        route_table.resource_group_key
      ].name

      bgp_route_propagation_enabled = (
        route_table.bgp_route_propagation_enabled
      )

      create = route_table.create
    }
  }


  # ==========================================================================
  # ROUTES
  # ==========================================================================

  routes = {
    for key, route in var.routes :
    key => {

      name = route.name

      resource_group_name = module.resource_groups[
        route.resource_group_key
      ].name

      route_table_key = route.route_table_key

      address_prefix = route.address_prefix

      next_hop_type = route.next_hop_type

      next_hop_in_ip_address = try(
        route.next_hop_in_ip_address,
        null
      )

      create = route.create
    }
  }


  # ==========================================================================
  # ROUTE TABLE → SUBNET ASSOCIATIONS
  # ==========================================================================

  route_table_subnet_associations = var.route_table_subnet_associations


  # ==========================================================================
  # PUBLIC IPs
  # ==========================================================================

  public_ips = {
    for key, pip in var.public_ips :
    key => {

      name = pip.name

      resource_group_name = module.resource_groups[
        pip.resource_group_key
      ].name

      create = pip.create
    }
  }


  # ==========================================================================
  # NAT GATEWAYS
  # ==========================================================================

  nat_gateways = {
    for key, nat in var.nat_gateways :
    key => {

      name = nat.name

      resource_group_name = module.resource_groups[
        nat.resource_group_key
      ].name

      vnet_key      = nat.vnet_key
      public_ip_key = nat.public_ip_key

      sku_name                = nat.sku_name
      idle_timeout_in_minutes = nat.idle_timeout_in_minutes

      create = nat.create
    }
  }


  # ==========================================================================
  # NAT GATEWAY → SUBNET
  # ==========================================================================

  nat_gateway_subnet_associations = (
    var.nat_gateway_subnet_associations
  )


  # ==========================================================================
  # VNET PEERINGS
  # ==========================================================================

  vnet_peerings = {
    for key, peering in var.vnet_peerings :
    key => {

      spoke_vnet_key = peering.spoke_vnet_key

      spoke_vnet_name = var.vnets[
        peering.spoke_vnet_key
      ].name

      spoke_resource_group_name = module.resource_groups[
        var.vnets[
          peering.spoke_vnet_key
        ].resource_group_key
      ].name

      hub_vnet_key = peering.hub_vnet_key

      hub_vnet_name = data.terraform_remote_state.hub.outputs.hub_vnet_name

      hub_resource_group_name = (
        data.terraform_remote_state.hub.outputs.hub_resource_group_name
      )

      spoke_to_hub_peering_name = (
        peering.spoke_to_hub_peering_name
      )

      hub_to_spoke_peering_name = (
        peering.hub_to_spoke_peering_name
      )

      allow_virtual_network_access = (
        peering.allow_virtual_network_access
      )

      allow_forwarded_traffic = (
        peering.allow_forwarded_traffic
      )

      allow_gateway_transit = (
        peering.allow_gateway_transit
      )

      use_remote_gateways = (
        peering.use_remote_gateways
      )

      create = peering.create
    }
  }


  # ==========================================================================
  # AZURE BASTION
  # ==========================================================================

  bastions = {
    for key, bastion in var.bastions :
    key => {

      name = bastion.name

      resource_group_name = module.resource_groups[
        bastion.resource_group_key
      ].name

      subnet_key    = bastion.subnet_key
      public_ip_key = bastion.public_ip_key

      ip_configuration_name = bastion.ip_configuration_name

      sku = bastion.sku

      tunneling_enabled      = bastion.tunneling_enabled
      ip_connect_enabled     = bastion.ip_connect_enabled
      shareable_link_enabled = bastion.shareable_link_enabled
      copy_paste_enabled     = bastion.copy_paste_enabled
      file_copy_enabled      = bastion.file_copy_enabled

      create = bastion.create
    }
  }


  # ==========================================================================
  # PRIVATE DNS ZONES
  # ==========================================================================

  private_dns_zones = {
    for key, zone in var.private_dns_zones :
    key => {

      name = zone.name

      resource_group_name = module.resource_groups[
        zone.resource_group_key
      ].name

      create = zone.create
    }
  }


  # ==========================================================================
  # PRIVATE DNS ZONE → VNET LINKS
  # ==========================================================================

  private_dns_zone_links = {
    for key, link in var.private_dns_zone_links :
    key => {

      name = link.name

      resource_group_name = module.resource_groups[
        link.resource_group_key
      ].name

      private_dns_zone_key = link.private_dns_zone_key

      vnet_key = link.vnet_key

      vnet_name = var.vnets[
        link.vnet_key
      ].name

      registration_enabled = link.registration_enabled

      create = link.create
    }
  }
}