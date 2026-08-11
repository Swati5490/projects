# Development Networking Configuration
# Virtual Networks, Subnets, and Network Security Groups
# Usage: terraform plan -var-file="environments/dev/_globals.tfvars" -var-file="environments/dev/networking.tfvars"

# ============================================================================
# VIRTUAL NETWORKS - Development (Count: 1 spoke VNet)
# Hub VNet is shared and created in Prod environment
# ============================================================================
vnets = {
  dev = {
    name          = "vnet-spoke-rewn-dev-cin"
    address_space = ["10.30.0.0/16"]
    environment   = "dev"
    dns_servers   = []
  }
}

# ============================================================================
# VNET PEERING - Hub (Prod) to Dev Spoke (Bidirectional)
# ============================================================================
vnet_peerings = {
  hub_to_dev = {
    name                             = "peer-hub-dev"
    source_vnet_name                 = "vnet-hub-rewn-prod-cin"
    source_vnet_rg                   = "rg-network-rewn-prod-cin"
    destination_vnet_name            = "vnet-spoke-rewn-dev-cin"
    destination_vnet_rg              = "rg-network-rewn-dev-cin"
    allow_virtual_network_access     = true
    allow_forwarded_traffic          = true
    allow_gateway_transit            = true
    use_remote_gateways              = false
  }
  dev_to_hub = {
    name                             = "peer-dev-hub"
    source_vnet_name                 = "vnet-spoke-rewn-dev-cin"
    source_vnet_rg                   = "rg-network-rewn-dev-cin"
    destination_vnet_name            = "vnet-hub-rewn-prod-cin"
    destination_vnet_rg              = "rg-network-rewn-prod-cin"
    allow_virtual_network_access     = true
    allow_forwarded_traffic          = true
    allow_gateway_transit            = false
    use_remote_gateways              = true
  }
}

# ============================================================================
# SUBNETS - Development (Count: 4 subnets)
# ============================================================================
subnets = {
  aks = {
    name                = "snet-aks-dev-cin"
    vnet_name           = "dev"
    address_prefixes    = ["10.30.0.0/22"]
    service_endpoints   = ["Microsoft.Storage"]
    nsg_association     = "aks"
  }
  databases = {
    name                = "snet-db-dev-cin"
    vnet_name           = "dev"
    address_prefixes    = ["10.30.4.0/24"]
    service_endpoints   = []
    nsg_association     = "databases"
  }
  storage = {
    name                = "snet-storage-dev-cin"
    vnet_name           = "dev"
    address_prefixes    = ["10.30.5.0/24"]
    service_endpoints   = ["Microsoft.Storage"]
    nsg_association     = "storage"
  }
  pe = {
    name                = "snet-pe-dev-cin"
    vnet_name           = "dev"
    address_prefixes    = ["10.30.6.0/24"]
    service_endpoints   = []
    nsg_association     = null
  }
}

# ============================================================================
# NETWORK SECURITY GROUPS - Development (Count: 3)
# ============================================================================
network_security_groups = {
  aks = {
    name                = "nsg-aks-dev-cin"
    priority            = 100
    direction           = "Inbound"
    access              = "Allow"
    protocol            = "Tcp"
    source_port_range   = "*"
    dest_port_range     = "6443"
    source_address      = ["10.10.0.0/16", "10.30.0.0/16"]
    destination_address = ["10.30.0.0/22"]
  }
  databases = {
    name                = "nsg-db-dev-cin"
    priority            = 100
    direction           = "Inbound"
    access              = "Allow"
    protocol            = "Tcp"
    source_port_range   = "*"
    dest_port_range     = "3306,27017,6379"
    source_address      = ["10.30.0.0/22"]
    destination_address = ["10.30.4.0/24"]
  }
  storage = {
    name                = "nsg-storage-dev-cin"
    priority            = 100
    direction           = "Inbound"
    access              = "Allow"
    protocol            = "Tcp"
    source_port_range   = "*"
    dest_port_range     = "443"
    source_address      = ["10.30.0.0/16", "10.10.0.0/16"]
    destination_address = ["10.30.5.0/24"]
  }
}

# ============================================================================
# ROUTE TABLES - Development (For outbound traffic via NAT)
# ============================================================================
route_tables = {
  dev = {
    name                               = "rt-dev-cin"
    disable_bgp_route_propagation      = false
  }
}

# ============================================================================
# ROUTES - To NAT Gateway for outbound internet access
# ============================================================================
routes = {
  to_nat = {
    name                   = "route-to-nat-dev"
    route_table_name       = "dev"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = null
  }
}

# ============================================================================
# NAT GATEWAY - Development (For secure outbound internet access)
# ============================================================================
nat_gateways = {
  dev = {
    name           = "nat-dev-cin"
    public_ip_name = "nat_dev"
    idle_timeout   = 4
    zones          = []
  }
}

# ============================================================================
# PUBLIC IPs - For NAT Gateway
# ============================================================================
public_ips = {
  nat_dev = {
    name                = "pip-nat-dev-cin"
    allocation_method   = "Static"
    sku                 = "Standard"
    zones               = []
  }
}

# ============================================================================
# SUBNET ROUTE TABLE ASSOCIATIONS - Associate subnets with NAT route table
# ============================================================================
subnet_route_table_associations = {
  aks_to_nat = {
    subnet_name      = "snet-aks-dev-cin"
    route_table_name = "rt-dev-cin"
  }
  databases_to_nat = {
    subnet_name      = "snet-db-dev-cin"
    route_table_name = "rt-dev-cin"
  }
  storage_to_nat = {
    subnet_name      = "snet-storage-dev-cin"
    route_table_name = "rt-dev-cin"
  }
}
