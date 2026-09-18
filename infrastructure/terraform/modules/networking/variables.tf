# ============================================================================
# NETWORKING MODULE - CHILD VARIABLES
# ============================================================================


# ============================================================================
# GLOBAL
# ============================================================================

variable "region" {
  description = "Azure deployment region"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "project_name" {
  description = "Project name"
  type        = string
}

variable "tags" {
  description = "Common resource tags"
  type        = map(string)
  default     = {}
}


# ============================================================================
# VIRTUAL NETWORKS
# ============================================================================

variable "vnets" {
  description = "Virtual Network configurations"

  type = map(object({
    name                = string
    resource_group_name = string
    address_space       = list(string)
    role                = string
    dns_servers         = list(string)
    create              = bool
  }))

  default = {}
}


# ============================================================================
# SUBNETS
# ============================================================================

variable "subnets" {
  description = "Subnet configurations"

  type = map(object({
    name                              = string
    resource_group_name               = string
    vnet_name                         = string
    address_prefixes                  = list(string)
    service_endpoints                 = list(string)
    private_endpoint_network_policies = string
    create                            = bool
  }))

  default = {}
}


# ============================================================================
# NETWORK SECURITY GROUPS
# ============================================================================

variable "network_security_groups" {
  description = "Network Security Group configurations"

  type = map(object({
    name                = string
    resource_group_name = string
    create              = bool
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
    resource_group_name           = string
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
    resource_group_name    = string
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
    name                = string
    resource_group_name = string
    create              = bool
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
    resource_group_name     = string
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

  description = "Hub and Spoke VNet peerings"

  type = map(object({

    # SPOKE
    spoke_vnet_key            = string
    spoke_vnet_name           = string
    spoke_resource_group_name = string

    # HUB
    hub_vnet_key              = string
    hub_vnet_name             = string
    hub_resource_group_name   = string

    # PEERING NAMES
    spoke_to_hub_peering_name = string
    hub_to_spoke_peering_name = string

    # COMMON
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
}


# ============================================================================
# AZURE BASTION
# ============================================================================

variable "bastions" {
  description = "Azure Bastion configurations"

  type = map(object({
    name                = string
    resource_group_name = string

    subnet_key    = string
    public_ip_key = string

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
    name                = string
    resource_group_name = string
    create              = bool
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
    resource_group_name  = string
    private_dns_zone_key = string
    vnet_key             = string
    vnet_name             = string
    registration_enabled = bool
    create               = bool
  }))

  default = {}
}

# ============================================================================
# HUB PRIVATE DNS ZONES
# ============================================================================

variable "hub_private_dns_zone_ids" {
  description = "Private DNS Zone IDs from Hub remote state"

  type    = map(string)
  default = {}
}

variable "hub_private_dns_zone_names" {
  description = "Private DNS Zone names from Hub remote state"

  type    = map(string)
  default = {}
}

# ============================================================================
# HUB VNET
# ============================================================================

variable "hub_vnet_id" {
  description = "Hub VNet ID from Hub remote state"

  type    = string
  default = null
}
