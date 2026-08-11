# Networking Module - variables.tf

variable "vnet_name" {
  description = "Name of the Virtual Network"
  type        = string
  default     = null
}

variable "subnet_name" {
  description = "Name of the subnet"
  type        = string
  default     = null
}

variable "nsg_name" {
  description = "Name of the Network Security Group"
  type        = string
  default     = null
}

variable "location" {
  description = "Azure location"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "address_space" {
  description = "Address space for VNet"
  type        = list(string)
  default     = []
}

variable "address_prefixes" {
  description = "Address prefixes for subnet"
  type        = list(string)
  default     = []
}

variable "dns_servers" {
  description = "DNS servers for VNet"
  type        = list(string)
  default     = []
}

variable "service_endpoints" {
  description = "Service endpoints for subnet"
  type        = list(string)
  default     = []
}

variable "delegation" {
  description = "Subnet delegation"
  type        = string
  default     = null
}

variable "nsg_association" {
  description = "Associated NSG name"
  type        = string
  default     = null
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "project_name" {
  description = "Project name"
  type        = string
}

variable "tags" {
  description = "Tags to apply"
  type        = map(string)
  default     = {}
}

# ============================================================================
# New Resources: VNet Peering, Route Tables, NAT Gateways, Bastion, DNS Zones
# ============================================================================

variable "vnet_peerings" {
  description = "Map of VNet peering configurations"
  type = map(object({
    name                             = string
    source_vnet_name                 = string
    source_vnet_rg                   = string
    destination_vnet_name            = string
    destination_vnet_rg              = string
    allow_virtual_network_access     = bool
    allow_forwarded_traffic          = bool
    allow_gateway_transit            = bool
    use_remote_gateways              = bool
  }))
  default = {}
}

variable "route_tables" {
  description = "Map of route table configurations"
  type = map(object({
    name = string
  }))
  default = {}
}

variable "routes" {
  description = "Map of route configurations"
  type = map(object({
    name                   = string
    route_table_name       = string
    address_prefix         = string
    next_hop_type          = string
    next_hop_in_ip_address = optional(string)
  }))
  default = {}
}

variable "nat_gateways" {
  description = "Map of NAT gateway configurations"
  type = map(object({
    name           = string
    public_ip_name = string
    idle_timeout   = number
    zones          = list(string)
  }))
  default = {}
}

variable "public_ips" {
  description = "Map of public IP configurations"
  type = map(object({
    name              = string
    allocation_method = string
    sku               = string
    zones             = list(string)
  }))
  default = {}
}

variable "bastions" {
  description = "Map of Azure Bastion configurations"
  type = map(object({
    name                     = string
    public_ip_name           = string
    subnet_name              = string
    tunneling_enabled        = bool
    ip_connect_enabled       = bool
    shareable_link_enabled   = bool
  }))
  default = {}
}

variable "private_dns_zones" {
  description = "Map of Private DNS Zone configurations"
  type = map(object({
    name = string
  }))
  default = {}
}
