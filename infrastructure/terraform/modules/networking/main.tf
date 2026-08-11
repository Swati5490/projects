# Networking Module - main.tf

# Virtual Network
resource "azurerm_virtual_network" "main" {
  count = var.vnet_name != null && length(var.address_space) > 0 ? 1 : 0

  name                = var.vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.address_space
  dns_servers         = length(var.dns_servers) > 0 ? var.dns_servers : null

  tags = merge(
    var.tags,
    {
      Environment = var.environment
    }
  )
}

# Subnet
resource "azurerm_subnet" "main" {
  count = var.subnet_name != null ? 1 : 0

  name                 = var.subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.vnet_name
  address_prefixes     = var.address_prefixes
  service_endpoints    = length(var.service_endpoints) > 0 ? var.service_endpoints : null

  depends_on = [azurerm_virtual_network.main]
}

# Network Security Group
resource "azurerm_network_security_group" "main" {
  count = var.nsg_name != null ? 1 : 0

  name                = var.nsg_name
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = merge(
    var.tags,
    {
      Environment = var.environment
    }
  )
}

# NSG Association with Subnet
resource "azurerm_subnet_network_security_group_association" "main" {
  count = (var.subnet_name != null && var.nsg_name != null) ? 1 : 0

  subnet_id                 = azurerm_subnet.main[0].id
  network_security_group_id = azurerm_network_security_group.main[0].id
}

# ============================================================================
# VNET PEERING
# ============================================================================
resource "azurerm_virtual_network_peering" "main" {
  for_each = var.vnet_peerings

  name                         = each.value.name
  resource_group_name          = var.resource_group_name
  virtual_network_name         = each.value.source_vnet_name
  remote_virtual_network_id    = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${each.value.destination_vnet_rg}/providers/Microsoft.Network/virtualNetworks/${each.value.destination_vnet_name}"
  allow_virtual_network_access = each.value.allow_virtual_network_access
  allow_forwarded_traffic      = each.value.allow_forwarded_traffic
  allow_gateway_transit        = each.value.allow_gateway_transit
  use_remote_gateways          = each.value.use_remote_gateways

  depends_on = [azurerm_virtual_network.main]
}

# ============================================================================
# ROUTE TABLES
# ============================================================================
resource "azurerm_route_table" "main" {
  for_each = var.route_tables

  name                = each.value.name
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = merge(
    var.tags,
    {
      Environment = var.environment
    }
  )
}

# ============================================================================
# ROUTES
# ============================================================================
resource "azurerm_route" "main" {
  for_each = var.routes

  name                   = each.value.name
  resource_group_name    = var.resource_group_name
  route_table_name       = each.value.route_table_name
  address_prefix         = each.value.address_prefix
  next_hop_type          = each.value.next_hop_type
  next_hop_in_ip_address = each.value.next_hop_in_ip_address

  depends_on = [azurerm_route_table.main]
}

# ============================================================================
# PUBLIC IPs
# ============================================================================
resource "azurerm_public_ip" "main" {
  for_each = var.public_ips

  name                = each.value.name
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = each.value.allocation_method
  sku                 = each.value.sku
  zones               = length(each.value.zones) > 0 ? each.value.zones : null

  tags = merge(
    var.tags,
    {
      Environment = var.environment
    }
  )
}

# ============================================================================
# NAT GATEWAYS
# ============================================================================
resource "azurerm_nat_gateway" "main" {
  for_each = var.nat_gateways

  name                = each.value.name
  location            = var.location
  resource_group_name = var.resource_group_name
  zones               = length(each.value.zones) > 0 ? each.value.zones : null

  tags = merge(
    var.tags,
    {
      Environment = var.environment
    }
  )
}

# Associate Public IPs with NAT Gateways
resource "azurerm_nat_gateway_public_ip_association" "main" {
  for_each = var.nat_gateways

  nat_gateway_id       = azurerm_nat_gateway.main[each.key].id
  public_ip_address_id = azurerm_public_ip.main[each.value.public_ip_name].id
}

# ============================================================================
# AZURE BASTION
# ============================================================================
resource "azurerm_bastion_host" "main" {
  for_each = var.bastions

  name                = each.value.name
  location            = var.location
  resource_group_name = var.resource_group_name
  ip_connect_enabled  = each.value.ip_connect_enabled
  tunneling_enabled   = each.value.tunneling_enabled
  shareable_link_enabled = each.value.shareable_link_enabled

  ip_configuration {
    name                 = "${each.value.name}-ip-config"
    subnet_id            = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Network/virtualNetworks/${var.vnet_name}/subnets/${each.value.subnet_name}"
    public_ip_address_id = azurerm_public_ip.main[each.value.public_ip_name].id
  }

  tags = merge(
    var.tags,
    {
      Environment = var.environment
    }
  )
}

# ============================================================================
# PRIVATE DNS ZONES
# ============================================================================
resource "azurerm_private_dns_zone" "main" {
  for_each = var.private_dns_zones

  name                = each.value.name
  resource_group_name = var.resource_group_name

  tags = merge(
    var.tags,
    {
      Environment = var.environment
    }
  )
}

# Data source to reference existing Virtual Network
data "azurerm_virtual_network" "existing" {
  count               = var.vnet_name != null ? 1 : 0
  name                = var.vnet_name
  resource_group_name = var.resource_group_name
}

# Link Private DNS Zones to VNet
resource "azurerm_private_dns_zone_virtual_network_link" "main" {
  for_each = var.private_dns_zones

  name                  = "${each.value.name}-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.main[each.key].name
  virtual_network_id    = var.vnet_name != null ? data.azurerm_virtual_network.existing[0].id : azurerm_virtual_network.main[0].id
  registration_enabled  = false
}

# ============================================================================
# DATA SOURCE - Current Azure client config (for subscription ID)
# ============================================================================
data "azurerm_client_config" "current" {}
