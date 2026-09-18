# ============================================================================
# NETWORKING - ROOT VARIABLES
# ============================================================================


# ============================================================================
# VIRTUAL NETWORKS
# ============================================================================

variable "vnets" {
  description = "Virtual Network configurations"

  type = map(object({
    name               = string
    resource_group_key = string
    address_space      = list(string)
    role               = string
    dns_servers        = list(string)
    create             = bool
  }))

  default = {}
}


# ============================================================================
# SUBNETS
# ============================================================================

variable "subnets" {
  description = "Subnet configurations"

  type = map(object({
    name                               = string
    resource_group_key                = string
    vnet_key                           = string
    address_prefixes                   = list(string)
    service_endpoints                  = list(string)
    private_endpoint_network_policies  = string
    create                             = bool
  }))

  default = {}
}


# ============================================================================
# NETWORK SECURITY GROUPS
# ============================================================================

variable "network_security_groups" {
  description = "Network Security Group configurations"

  type = map(object({
    name               = string
    resource_group_key = string
    create             = bool
  }))

  default = {}
}


# ============================================================================
# NSG → SUBNET ASSOCIATIONS
# ============================================================================

variable "nsg_subnet_associations" {
  description = "NSG to subnet associations"

  type = map(object({
    subnet_key = string
    nsg_key    = string
    create     = bool
  }))

  default = {}
}


# ============================================================================
# ROUTE TABLES
# ============================================================================

variable "route_tables" {
  description = "Route table configurations"

  type = map(object({
    name                          = string
    resource_group_key            = string
    bgp_route_propagation_enabled = bool
    create                        = bool
  }))

  default = {}
}


# ============================================================================
# ROUTES
# ============================================================================

variable "routes" {
  description = "Route configurations"

  type = map(object({
    name                   = string
    resource_group_key     = string
    route_table_key        = string
    address_prefix         = string
    next_hop_type          = string
    next_hop_in_ip_address = optional(string)
    create                 = bool
  }))

  default = {}
}


# ============================================================================
# ROUTE TABLE → SUBNET ASSOCIATIONS
# ============================================================================

variable "route_table_subnet_associations" {
  description = "Route table to subnet associations"

  type = map(object({
    subnet_key      = string
    route_table_key = string
    create          = bool
  }))

  default = {}
}


# ============================================================================
# PUBLIC IPs
# ============================================================================

variable "public_ips" {
  description = "Public IP configurations"

  type = map(object({
    name               = string
    resource_group_key = string
    create             = bool
  }))

  default = {}
}


# ============================================================================
# NAT GATEWAYS
# ============================================================================

variable "nat_gateways" {
  description = "NAT Gateway configurations"

  type = map(object({
    name                    = string
    resource_group_key      = string
    vnet_key                = string
    public_ip_key           = string
    sku_name                = string
    idle_timeout_in_minutes = number
    create                  = bool
  }))

  default = {}
}


# ============================================================================
# NAT GATEWAY → SUBNET ASSOCIATIONS
# ============================================================================

variable "nat_gateway_subnet_associations" {
  description = "NAT Gateway to subnet associations"

  type = map(object({
    subnet_key      = string
    nat_gateway_key = string
    create          = bool
  }))

  default = {}
}


# ============================================================================
# VNET PEERINGS
# ============================================================================

variable "vnet_peerings" {

  type = map(object({

    spoke_vnet_key = string
    hub_vnet_key   = string

    spoke_to_hub_peering_name = string
    hub_to_spoke_peering_name = string

    allow_virtual_network_access = bool
    allow_forwarded_traffic      = bool

    # SPOKE → HUB
    spoke_to_hub_allow_gateway_transit = bool
    spoke_to_hub_use_remote_gateways   = bool

    # HUB → SPOKE
    hub_to_spoke_allow_gateway_transit = bool
    hub_to_spoke_use_remote_gateways   = bool

    create = bool
  }))

  default = {}
}


# ============================================================================
# AZURE BASTION
# ============================================================================

variable "bastions" {
  description = "Azure Bastion configurations"

  type = map(object({
    name               = string
    resource_group_key = string
    subnet_key         = string
    public_ip_key      = string

    ip_configuration_name = string
    sku                   = string

    tunneling_enabled      = bool
    ip_connect_enabled     = bool
    shareable_link_enabled = bool
    copy_paste_enabled     = bool
    file_copy_enabled      = bool

    create = bool
  }))

  default = {}
}


# ============================================================================
# PRIVATE DNS ZONES
# ============================================================================

variable "private_dns_zones" {
  description = "Private DNS zone configurations"

  type = map(object({
    name               = string
    resource_group_key = string
    create             = bool
  }))

  default = {}
}


# ============================================================================
# PRIVATE DNS ZONE → VNET LINKS
# ============================================================================

variable "private_dns_zone_links" {
  description = "Private DNS zone VNet links"

  type = map(object({
    name                 = string
    resource_group_key   = string
    private_dns_zone_key = string
    vnet_key             = string
    registration_enabled = bool
    create               = bool
  }))

  default = {}
}