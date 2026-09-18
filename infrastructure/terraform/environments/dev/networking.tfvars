# ============================================================================
# DEV SPOKE NETWORKING
# ============================================================================

vnets = {
  vnet_spoke_dev = {
    name               = "vnet-spoke-rewn-dev"
    resource_group_key = "rg_network"

    address_space = ["10.30.0.0/16"]

    role        = "spoke"
    dns_servers = []
    create      = true
  }
}


# ============================================================================
# DEV SUBNETS
# ============================================================================

subnets = {

  snet_database = {
    name               = "snet-db-dev"
    resource_group_key = "rg_network"
    vnet_key           = "vnet_spoke_dev"

    address_prefixes = ["10.30.16.0/22"]

    service_endpoints = ["Microsoft.Sql"]

    private_endpoint_network_policies = "Disabled"
    delegation                        = []
    create                            = true
  }


  snet_storage = {
    name               = "snet-storage-dev"
    resource_group_key = "rg_network"
    vnet_key           = "vnet_spoke_dev"

    address_prefixes = ["10.30.20.0/22"]

    service_endpoints = ["Microsoft.Storage"]

    private_endpoint_network_policies = "Disabled"
    delegation                        = []
    create                            = true
  }


  snet_pe = {
    name               = "snet-pe-dev"
    resource_group_key = "rg_network"
    vnet_key           = "vnet_spoke_dev"

    address_prefixes = ["10.30.24.0/24"]

    service_endpoints = []

    private_endpoint_network_policies = "Disabled"
    delegation                        = []
    create                            = true
  }


  snet_app = {
    name               = "snet-app-dev"
    resource_group_key = "rg_network"
    vnet_key           = "vnet_spoke_dev"

  # Dedicated subnet for Azure Container Apps Environment
    address_prefixes = ["10.30.0.0/20"]

    service_endpoints = []

    private_endpoint_network_policies = "Disabled"

    delegation = [
      {
        name = "delegation-containerapps"

        service_delegation = {
        name = "Microsoft.App/environments"

        actions = [
          "Microsoft.Network/virtualNetworks/subnets/action"
        ]
      }
    }
  ]

  create = true
  }


  snet_data_vm = {
    name               = "snet-data-vm-dev"
    resource_group_key = "rg_network"
    vnet_key           = "vnet_spoke_dev"

    address_prefixes = ["10.30.26.0/23"]

    service_endpoints = []

    private_endpoint_network_policies = "Disabled"
    delegation                        = []
    create                            = true
  }
}


# ============================================================================
# NSGs
# ============================================================================

network_security_groups = {

  nsg_database = {
    name               = "nsg-db-dev"
    resource_group_key = "rg_network"
    create             = true
  }

  nsg_storage = {
    name               = "nsg-storage-dev"
    resource_group_key = "rg_network"
    create             = true
  }

  nsg_pe = {
    name               = "nsg-pe-dev"
    resource_group_key = "rg_network"
    create             = true
  }

  nsg_app = {
    name               = "nsg-app-dev"
    resource_group_key = "rg_network"
    create             = true
  }

  nsg_data_vm = {
    name               = "nsg-data-vm-dev"
    resource_group_key = "rg_network"
    create             = true
  }
}


# ============================================================================
# NSG → SUBNET ASSOCIATIONS
# ============================================================================

nsg_subnet_associations = {

  database_nsg_subnet = {
    subnet_key = "snet_database"
    nsg_key    = "nsg_database"
    create     = true
  }

  storage_nsg_subnet = {
    subnet_key = "snet_storage"
    nsg_key    = "nsg_storage"
    create     = true
  }

  pe_nsg_subnet = {
    subnet_key = "snet_pe"
    nsg_key    = "nsg_pe"
    create     = true
  }

  app_nsg_subnet = {
    subnet_key = "snet_app"
    nsg_key    = "nsg_app"
    create     = true
  }

  data_vm_nsg_subnet = {
    subnet_key = "snet_data_vm"
    nsg_key    = "nsg_data_vm"
    create     = true
  }
}


# ============================================================================
# ROUTE TABLES
# ============================================================================

route_tables = {

  rt_database = {
    name                          = "rt-database-dev"
    resource_group_key            = "rg_network"
    bgp_route_propagation_enabled = true
    create                        = true
  }

  rt_storage = {
    name                          = "rt-storage-dev"
    resource_group_key            = "rg_network"
    bgp_route_propagation_enabled = true
    create                        = true
  }

  rt_pe = {
    name                          = "rt-pe-dev"
    resource_group_key            = "rg_network"
    bgp_route_propagation_enabled = true
    create                        = true
  }

  rt_app = {
    name                          = "rt-app-dev"
    resource_group_key            = "rg_network"
    bgp_route_propagation_enabled = true
    create                        = true
  }

  rt_data_vm = {
    name                          = "rt-data-vm-dev"
    resource_group_key            = "rg_network"
    bgp_route_propagation_enabled = true
    create                        = true
  }
}

routes = {}


# ============================================================================
# ROUTE TABLE → SUBNET ASSOCIATIONS
# ============================================================================

route_table_subnet_associations = {

  database_rt_subnet = {
    subnet_key      = "snet_database"
    route_table_key = "rt_database"
    create          = true
  }

  storage_rt_subnet = {
    subnet_key      = "snet_storage"
    route_table_key = "rt_storage"
    create          = true
  }

  pe_rt_subnet = {
    subnet_key      = "snet_pe"
    route_table_key = "rt_pe"
    create          = true
  }

  app_rt_subnet = {
    subnet_key      = "snet_app"
    route_table_key = "rt_app"
    create          = true
  }

  data_vm_rt_subnet = {
    subnet_key      = "snet_data_vm"
    route_table_key = "rt_data_vm"
    create          = true
  }
}


# ============================================================================
# NAT GATEWAY - DISABLED
# ============================================================================

public_ips = {
  pip_nat_dev = {
    name               = "pip-natgw-dev"
    resource_group_key = "rg_network"
    create             = false
  }
}

nat_gateways = {
  natgw_dev = {
    name               = "natgw-rewn-dev"
    resource_group_key = "rg_network"

    vnet_key      = "vnet_spoke_dev"
    public_ip_key = "pip_nat_dev"

    sku_name                = "Standard"
    idle_timeout_in_minutes = 10
    create                  = false
  }
}

nat_gateway_subnet_associations = {}


# ============================================================================
# VNET PEERING
# ============================================================================

vnet_peerings = {

  spoke_dev_hub = {

    spoke_vnet_key = "vnet_spoke_dev"
    hub_vnet_key   = "vnet_hub"

    spoke_to_hub_peering_name = "peer-spoke-dev-to-hub"
    hub_to_spoke_peering_name = "peer-hub-to-spoke-dev"

    allow_virtual_network_access = true
    allow_forwarded_traffic      = true

    # SPOKE → HUB
    spoke_to_hub_allow_gateway_transit = false
    spoke_to_hub_use_remote_gateways   = true

    # HUB → SPOKE
    hub_to_spoke_allow_gateway_transit = true
    hub_to_spoke_use_remote_gateways   = false

    create = true
  }
}


bastions = {}

private_dns_zones = {}


# ============================================================================
# PRIVATE DNS ZONE → DEV VNET LINKS
# ============================================================================

private_dns_zone_links = {

  mysql_spoke = {
    name                 = "link-mysql-dev"
    resource_group_key   = "rg_network"
    private_dns_zone_key = "dns_mysql"
    vnet_key             = "vnet_spoke_dev"

    registration_enabled = false
    create               = true
  }

  storage_spoke = {
    name                 = "link-storage-dev"
    resource_group_key   = "rg_network"
    private_dns_zone_key = "dns_storage"
    vnet_key             = "vnet_spoke_dev"

    registration_enabled = false
    create               = true
  }

  redis_spoke = {
    name                 = "link-redis-dev"
    resource_group_key   = "rg_network"
    private_dns_zone_key = "dns_redis"
    vnet_key             = "vnet_spoke_dev"

    registration_enabled = false
    create               = true
  }

  cosmos_dns_link = {
    name                 = "link-cosmos-dev"
    resource_group_key   = "rg_network"
    private_dns_zone_key = "dns_cosmos"
    vnet_key             = "vnet_spoke_dev"

    registration_enabled = false
    create               = true
  }
}