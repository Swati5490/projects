# ============================================================================
# VIRTUAL NETWORKS
# ============================================================================

resource "azurerm_virtual_network" "main" {

  for_each = {
    for key, vnet in var.vnets :
    key => vnet
    if vnet.create
  }

  name                = each.value.name
  location            = var.region
  resource_group_name = each.value.resource_group_name

  address_space = each.value.address_space
  dns_servers   = each.value.dns_servers

  tags = var.tags
}


# ============================================================================
# SUBNETS
# ============================================================================

resource "azurerm_subnet" "main" {

  for_each = {
    for key, subnet in var.subnets :
    key => subnet
    if subnet.create
  }

  name                = each.value.name
  resource_group_name = each.value.resource_group_name

  virtual_network_name = each.value.vnet_name

  address_prefixes  = each.value.address_prefixes
  service_endpoints = each.value.service_endpoints

  private_endpoint_network_policies = (
    each.value.private_endpoint_network_policies
  )

  depends_on = [
    azurerm_virtual_network.main
  ]
}


# ============================================================================
# NETWORK SECURITY GROUPS
# ============================================================================

resource "azurerm_network_security_group" "main" {

  for_each = {
    for key, nsg in var.network_security_groups :
    key => nsg
    if nsg.create
  }

  name                = each.value.name
  location            = var.region
  resource_group_name = each.value.resource_group_name

  tags = var.tags
}


# ============================================================================
# NSG → SUBNET ASSOCIATIONS
# ============================================================================

resource "azurerm_subnet_network_security_group_association" "main" {

  for_each = {
    for key, association in var.nsg_subnet_associations :
    key => association
    if association.create
  }

  subnet_id = azurerm_subnet.main[
    each.value.subnet_key
  ].id

  network_security_group_id = azurerm_network_security_group.main[
    each.value.nsg_key
  ].id

  depends_on = [
    azurerm_subnet.main,
    azurerm_network_security_group.main
  ]
}


# ============================================================================
# ROUTE TABLES
# ============================================================================

resource "azurerm_route_table" "main" {

  for_each = {
    for key, route_table in var.route_tables :
    key => route_table
    if route_table.create
  }

  name                = each.value.name
  location            = var.region
  resource_group_name = each.value.resource_group_name

  bgp_route_propagation_enabled = (
    each.value.bgp_route_propagation_enabled
  )

  tags = var.tags
}


# ============================================================================
# ROUTES
# ============================================================================

resource "azurerm_route" "main" {

  for_each = {
    for key, route in var.routes :
    key => route
    if route.create
  }

  name                = each.value.name
  resource_group_name = each.value.resource_group_name

  route_table_name = azurerm_route_table.main[
    each.value.route_table_key
  ].name

  address_prefix = each.value.address_prefix
  next_hop_type  = each.value.next_hop_type

  next_hop_in_ip_address = each.value.next_hop_in_ip_address

  depends_on = [
    azurerm_route_table.main
  ]
}


# ============================================================================
# ROUTE TABLE → SUBNET ASSOCIATIONS
# ============================================================================

resource "azurerm_subnet_route_table_association" "main" {

  for_each = {
    for key, association in var.route_table_subnet_associations :
    key => association
    if association.create
  }

  subnet_id = azurerm_subnet.main[
    each.value.subnet_key
  ].id

  route_table_id = azurerm_route_table.main[
    each.value.route_table_key
  ].id

  depends_on = [
    azurerm_subnet.main,
    azurerm_route_table.main
  ]
}


# ============================================================================
# PUBLIC IPs
# ============================================================================

resource "azurerm_public_ip" "main" {

  for_each = {
    for key, pip in var.public_ips :
    key => pip
    if pip.create
  }

  name                = each.value.name
  location            = var.region
  resource_group_name = each.value.resource_group_name

  allocation_method = "Static"
  sku               = "Standard"
  zones = try(each.value.zones, [])
  tags = var.tags
}


# ============================================================================
# NAT GATEWAYS
# ============================================================================

resource "azurerm_nat_gateway" "main" {

  for_each = {
    for key, nat in var.nat_gateways :
    key => nat
    if nat.create
  }

  name                = each.value.name
  location            = var.region
  resource_group_name = each.value.resource_group_name

  sku_name                = each.value.sku_name
  idle_timeout_in_minutes = each.value.idle_timeout_in_minutes

  tags = var.tags
}


# ============================================================================
# NAT GATEWAY → PUBLIC IP ASSOCIATION
# ============================================================================

resource "azurerm_nat_gateway_public_ip_association" "main" {

  for_each = {
    for key, nat in var.nat_gateways :
    key => nat
    if nat.create
  }

  nat_gateway_id = azurerm_nat_gateway.main[
    each.key
  ].id

  public_ip_address_id = azurerm_public_ip.main[
    each.value.public_ip_key
  ].id

  depends_on = [
    azurerm_nat_gateway.main,
    azurerm_public_ip.main
  ]
}


# ============================================================================
# NAT GATEWAY → SUBNET ASSOCIATIONS
# ============================================================================

resource "azurerm_subnet_nat_gateway_association" "main" {

  for_each = {
    for key, association in var.nat_gateway_subnet_associations :
    key => association
    if association.create
  }

  subnet_id = azurerm_subnet.main[
    each.value.subnet_key
  ].id

  nat_gateway_id = azurerm_nat_gateway.main[
    each.value.nat_gateway_key
  ].id

  depends_on = [
    azurerm_subnet.main,
    azurerm_nat_gateway.main
  ]
}


# ============================================================================
# SPOKE → HUB VNET PEERING
# ============================================================================

resource "azurerm_virtual_network_peering" "spoke_to_hub" {

  for_each = {
    for key, peering in var.vnet_peerings :
    key => peering
    if peering.create
  }

  name = each.value.spoke_to_hub_peering_name

  resource_group_name = each.value.spoke_resource_group_name

  virtual_network_name = each.value.spoke_vnet_name

  # IMPORTANT: Hub VNet comes from remote state
  remote_virtual_network_id = var.hub_vnet_id

  allow_virtual_network_access = each.value.allow_virtual_network_access
  allow_forwarded_traffic      = each.value.allow_forwarded_traffic
  allow_gateway_transit = each.value.spoke_to_hub_allow_gateway_transit
  use_remote_gateways   = each.value.spoke_to_hub_use_remote_gateways

  depends_on = [
    azurerm_virtual_network.main
  ]
}


# ============================================================================
# HUB → SPOKE VNET PEERING
# ============================================================================

resource "azurerm_virtual_network_peering" "hub_to_spoke" {

  for_each = {
    for key, peering in var.vnet_peerings :
    key => peering
    if peering.create
  }

  name = each.value.hub_to_spoke_peering_name

  resource_group_name = each.value.hub_resource_group_name

  virtual_network_name = each.value.hub_vnet_name

  # Spoke VNet is created locally
  remote_virtual_network_id = azurerm_virtual_network.main[
    each.value.spoke_vnet_key
  ].id

  allow_virtual_network_access = each.value.allow_virtual_network_access
  allow_forwarded_traffic      = each.value.allow_forwarded_traffic
  allow_gateway_transit = each.value.hub_to_spoke_allow_gateway_transit
  use_remote_gateways   = each.value.hub_to_spoke_use_remote_gateways

  depends_on = [
    azurerm_virtual_network.main
  ]
}


# ============================================================================
# AZURE BASTION
# ============================================================================

resource "azurerm_bastion_host" "main" {

  for_each = {
    for key, bastion in var.bastions :
    key => bastion
    if bastion.create
  }

  name                = each.value.name
  location            = var.region
  resource_group_name = each.value.resource_group_name

  sku = each.value.sku

  tunneling_enabled      = each.value.tunneling_enabled
  ip_connect_enabled     = each.value.ip_connect_enabled
  shareable_link_enabled = each.value.shareable_link_enabled
  copy_paste_enabled     = each.value.copy_paste_enabled
  file_copy_enabled      = each.value.file_copy_enabled

  ip_configuration {
    name = each.value.ip_configuration_name

    subnet_id = azurerm_subnet.main[
      each.value.subnet_key
    ].id

    public_ip_address_id = azurerm_public_ip.main[
      each.value.public_ip_key
    ].id
  }

  depends_on = [
    azurerm_subnet.main,
    azurerm_public_ip.main
  ]
}

# ============================================================================
# PRIVATE DNS ZONES
# ============================================================================

resource "azurerm_private_dns_zone" "main" {

  for_each = {
    for key, zone in var.private_dns_zones :
    key => zone
    if zone.create
  }

  name                = each.value.name
  resource_group_name = each.value.resource_group_name

  tags = var.tags
}
# ============================================================================
# PRIVATE DNS ZONES
# ============================================================================

resource "azurerm_private_dns_zone_virtual_network_link" "main" {

  for_each = {
    for key, link in var.private_dns_zone_links :
    key => link
    if link.create
  }

  name = each.value.name

  # DNS zones are centrally managed in HUB
  # Therefore the VNet link is created in HUB DNS Zone's RG
  resource_group_name = "rg-network-rewn"

  # Existing DNS zone comes from HUB remote state
  private_dns_zone_name = var.hub_private_dns_zone_names[
    each.value.private_dns_zone_key
  ]

  # Spoke VNet is local to this environment
  virtual_network_id = azurerm_virtual_network.main[
    each.value.vnet_key
  ].id

  registration_enabled = each.value.registration_enabled

  depends_on = [
    azurerm_virtual_network.main
  ]
}