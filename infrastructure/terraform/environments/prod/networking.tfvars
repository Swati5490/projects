# Production Networking Configuration
# Virtual Networks, Subnets, and Network Security Groups
# Usage: terraform plan -var-file="environments/prod/_globals.tfvars" -var-file="environments/prod/networking.tfvars"

# ============================================================================
# VIRTUAL NETWORKS - Production (Count: 2)
# ============================================================================
vnets = {
  hub = {
    name          = "vnet-hub-rewn-prod-cin"
    address_space = ["10.10.0.0/16"]
    environment   = "prod"
    dns_servers   = ["8.8.8.8", "8.8.4.4"]
  }
  spoke_prod = {
    name          = "vnet-spoke-rewn-prod-cin"
    address_space = ["10.20.0.0/16"]
    environment   = "prod"
    dns_servers   = []
  }
}

# ============================================================================
# SUBNETS - Production (Count: 6 subnets)
# ============================================================================
subnets = {
  appgw = {
    name                = "snet-appgw-rewn-cin"
    vnet_name           = "hub"
    address_prefixes    = ["10.10.0.0/24"]
    service_endpoints   = ["Microsoft.Storage", "Microsoft.Sql"]
    nsg_association     = "appgw"
  }
  aks = {
    name                = "snet-aks-prod-cin"
    vnet_name           = "hub"
    address_prefixes    = ["10.10.1.0/22"]
    service_endpoints   = ["Microsoft.Storage"]
    nsg_association     = "aks"
  }
  databases = {
    name                = "snet-db-prod-cin"
    vnet_name           = "hub"
    address_prefixes    = ["10.10.5.0/24"]
    service_endpoints   = []
    nsg_association     = "databases"
  }
  storage = {
    name                = "snet-storage-prod-cin"
    vnet_name           = "hub"
    address_prefixes    = ["10.10.6.0/24"]
    service_endpoints   = ["Microsoft.Storage"]
    nsg_association     = "storage"
  }
  pe = {
    name                = "snet-pe-prod-cin"
    vnet_name           = "hub"
    address_prefixes    = ["10.10.7.0/24"]
    service_endpoints   = []
    nsg_association     = "pe"
  }
  bastion = {
    name                = "snet-bastion-prod-cin"
    vnet_name           = "hub"
    address_prefixes    = ["10.10.8.0/27"]
    service_endpoints   = []
    nsg_association     = "bastion"
  }
}

# ============================================================================
# NETWORK SECURITY GROUPS - Production (Count: 6)
# ============================================================================
network_security_groups = {
  appgw = {
    name                = "nsg-appgw-rewn-cin"
    priority            = 100
    direction           = "Inbound"
    access              = "Allow"
    protocol            = "Tcp"
    source_port_range   = "*"
    dest_port_range     = "443"
    source_address      = ["*"]
    destination_address = ["10.10.0.0/24"]
  }
  aks = {
    name                = "nsg-aks-prod-cin"
    priority            = 100
    direction           = "Inbound"
    access              = "Allow"
    protocol            = "Tcp"
    source_port_range   = "*"
    dest_port_range     = "6443"
    source_address      = ["10.10.0.0/16"]
    destination_address = ["10.10.1.0/22"]
  }
  databases = {
    name                = "nsg-db-prod-cin"
    priority            = 100
    direction           = "Inbound"
    access              = "Allow"
    protocol            = "Tcp"
    source_port_range   = "*"
    dest_port_range     = "3306"
    source_address      = ["10.10.1.0/22"]
    destination_address = ["10.10.5.0/24"]
  }
  storage = {
    name                = "nsg-storage-prod-cin"
    priority            = 100
    direction           = "Inbound"
    access              = "Allow"
    protocol            = "Tcp"
    source_port_range   = "*"
    dest_port_range     = "445"
    source_address      = ["10.10.1.0/22"]
    destination_address = ["10.10.6.0/24"]
  }
  pe = {
    name                = "nsg-pe-prod-cin"
    priority            = 100
    direction           = "Inbound"
    access              = "Allow"
    protocol            = "Tcp"
    source_port_range   = "*"
    dest_port_range     = "443"
    source_address      = ["10.10.0.0/16"]
    destination_address = ["10.10.7.0/24"]
  }
  bastion = {
    name                = "nsg-bastion-prod-cin"
    priority            = 100
    direction           = "Inbound"
    access              = "Allow"
    protocol            = "Tcp"
    source_port_range   = "*"
    dest_port_range     = "3389"
    source_address      = ["*"]
    destination_address = ["10.10.8.0/27"]
  }
}

# ============================================================================
# VNET PEERING - Hub to Prod Spoke (Bidirectional)
# ============================================================================
vnet_peerings = {
  hub_to_prod = {
    name                             = "peer-hub-prod"
    source_vnet_name                 = "hub"
    source_vnet_rg                   = "network"
    destination_vnet_name            = "spoke_prod"
    destination_vnet_rg              = "network"
    allow_virtual_network_access     = true
    allow_forwarded_traffic          = true
    allow_gateway_transit            = true
    use_remote_gateways              = false
  }
  prod_to_hub = {
    name                             = "peer-prod-hub"
    source_vnet_name                 = "spoke_prod"
    source_vnet_rg                   = "network"
    destination_vnet_name            = "hub"
    destination_vnet_rg              = "network"
    allow_virtual_network_access     = true
    allow_forwarded_traffic          = true
    allow_gateway_transit            = false
    use_remote_gateways              = false
  }
}

# ============================================================================
# ROUTE TABLES - Production (For traffic routing)
# ============================================================================
route_tables = {
  prod = {
    name                               = "rt-prod-cin"
    disable_bgp_route_propagation      = false
  }
}

# ============================================================================
# ROUTES - To NAT Gateway for outbound internet access
# ============================================================================
routes = {
  to_nat = {
    name                   = "route-to-nat-prod"
    route_table_name       = "prod"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = null
  }
}

# ============================================================================
# NAT GATEWAY - Production (For secure outbound internet access)
# ============================================================================
nat_gateways = {
  prod = {
    name           = "nat-prod-cin"
    public_ip_name = "nat_prod"
    idle_timeout   = 4
    zones          = ["1", "2", "3"]
  }
}

# ============================================================================
# PUBLIC IPs - For NAT Gateway, AppGW, and Bastion
# ============================================================================
public_ips = {
  appgw = {
    name                = "pip-appgw-rewn-cin"
    allocation_method   = "Static"
    sku                 = "Standard"
    zones               = ["1", "2", "3"]
  }
  bastion = {
    name                = "pip-bastion-prod-cin"
    allocation_method   = "Static"
    sku                 = "Standard"
    zones               = []
  }
  nat_prod = {
    name                = "pip-nat-prod-cin"
    allocation_method   = "Static"
    sku                 = "Standard"
    zones               = []
  }
}

# ============================================================================
# AZURE BASTION - Jump host for secure access
# ============================================================================
bastions = {
  prod = {
    name                = "bas-prod-cin"
    public_ip_name      = "bastion"
    subnet_name         = "snet-bastion-prod-cin"
    tunneling_enabled   = false
    ip_connect_enabled  = false
    shareable_link_enabled = false
  }
}

# ============================================================================
# PRIVATE DNS ZONES - For Private Endpoints
# ============================================================================
private_dns_zones = {
  mysql = {
    name = "privatelink.mysql.database.azure.com"
  }
  blob = {
    name = "privatelink.blob.core.windows.net"
  }
  keyvault = {
    name = "privatelink.vaultcore.azure.net"
  }
}
