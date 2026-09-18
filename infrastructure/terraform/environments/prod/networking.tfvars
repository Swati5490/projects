# ============================================================================
# PROD SPOKE NETWORKING
# ============================================================================

# ============================================================================
# VIRTUAL NETWORK
# ============================================================================

vnets = {

  vnet_spoke_prod = {

    name               = "vnet-spoke-rewn-prod"
    resource_group_key = "rg_network"

    address_space = [
      "10.20.0.0/16"
    ]

    role        = "spoke"
    dns_servers = []

    create = true
  }
}

# ============================================================================
# PROD SUBNETS
# ============================================================================

subnets = {

  # --------------------------------------------------------------------------
  # CONTAINER APPS
  # --------------------------------------------------------------------------

  snet_container_app = {

    name               = "snet-container-app-prod"
    resource_group_key = "rg_network"
    vnet_key            = "vnet_spoke_prod"

    address_prefixes = [
      "10.20.0.0/20"
    ]

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

  # --------------------------------------------------------------------------
  # APPLICATION VMs
  # --------------------------------------------------------------------------

  snet_app_vm = {

    name               = "snet-app-vm-prod"
    resource_group_key = "rg_network"
    vnet_key            = "vnet_spoke_prod"

    address_prefixes = [
      "10.20.30.0/23"
    ]

    service_endpoints = []

    private_endpoint_network_policies = "Disabled"

    delegation = []

    create = true
  }

  # --------------------------------------------------------------------------
  # DATABASE
  # --------------------------------------------------------------------------

  snet_database = {

    name               = "snet-db-prod"
    resource_group_key = "rg_network"
    vnet_key            = "vnet_spoke_prod"

    address_prefixes = [
      "10.20.16.0/22"
    ]

    service_endpoints = [
      "Microsoft.Sql"
    ]

    private_endpoint_network_policies = "Disabled"

    delegation = []

    create = true
  }

  # --------------------------------------------------------------------------
  # STORAGE
  # --------------------------------------------------------------------------

  snet_storage = {

    name               = "snet-storage-prod"
    resource_group_key = "rg_network"
    vnet_key            = "vnet_spoke_prod"

    address_prefixes = [
      "10.20.20.0/22"
    ]

    service_endpoints = [
      "Microsoft.Storage"
    ]

    private_endpoint_network_policies = "Disabled"

    delegation = []

    create = true
  }

  # --------------------------------------------------------------------------
  # PRIVATE ENDPOINTS
  # --------------------------------------------------------------------------

  snet_pe = {

    name               = "snet-pe-prod"
    resource_group_key = "rg_network"
    vnet_key            = "vnet_spoke_prod"

    address_prefixes = [
      "10.20.24.0/24"
    ]

    service_endpoints = []

    private_endpoint_network_policies = "Disabled"

    delegation = []

    create = true
  }

  # --------------------------------------------------------------------------
  # DATA VMs
  # MongoDB / Elasticsearch
  # --------------------------------------------------------------------------

  snet_data_vm = {

    name               = "snet-data-vm-prod"
    resource_group_key = "rg_network"
    vnet_key            = "vnet_spoke_prod"

    address_prefixes = [
      "10.20.26.0/23"
    ]

    service_endpoints = []

    private_endpoint_network_policies = "Disabled"

    delegation = []

    create = true
  }

  snet_appgw = {
    name               = "snet-appgw-prod"
    resource_group_key = "rg_network"
    vnet_key            = "vnet_spoke_prod"

    address_prefixes = [
      "10.20.28.0/24"
    ]

    service_endpoints = []

    private_endpoint_network_policies = "Disabled"

    create = true
  }
}

# ============================================================================
# NETWORK SECURITY GROUPS
# ============================================================================

network_security_groups = {

  nsg_container_app = {

    name               = "nsg-container-app-prod"
    resource_group_key = "rg_network"

    create = true
  }

  nsg_app_vm = {

    name               = "nsg-app-vm-prod"
    resource_group_key = "rg_network"

    create = true
  }

  nsg_database = {

    name               = "nsg-db-prod"
    resource_group_key = "rg_network"

    create = true
  }

  nsg_storage = {

    name               = "nsg-storage-prod"
    resource_group_key = "rg_network"

    create = true
  }

  nsg_pe = {

    name               = "nsg-pe-prod"
    resource_group_key = "rg_network"

    create = true
  }

  nsg_data_vm = {

    name               = "nsg-data-vm-prod"
    resource_group_key = "rg_network"

    create = true
  }
}

# ============================================================================
# NSG → SUBNET ASSOCIATIONS
# ============================================================================

nsg_subnet_associations = {

  container_app_nsg_subnet = {

    subnet_key = "snet_container_app"
    nsg_key    = "nsg_container_app"

    create = true
  }

  app_vm_nsg_subnet = {

    subnet_key = "snet_app_vm"
    nsg_key    = "nsg_app_vm"

    create = true
  }

  database_nsg_subnet = {

    subnet_key = "snet_database"
    nsg_key    = "nsg_database"

    create = true
  }

  storage_nsg_subnet = {

    subnet_key = "snet_storage"
    nsg_key    = "nsg_storage"

    create = true
  }

  pe_nsg_subnet = {

    subnet_key = "snet_pe"
    nsg_key    = "nsg_pe"

    create = true
  }

  data_vm_nsg_subnet = {

    subnet_key = "snet_data_vm"
    nsg_key    = "nsg_data_vm"

    create = true
  }
}

# ============================================================================
# ROUTE TABLES
# ============================================================================

route_tables = {

  rt_container_apps = {

    name               = "rt-ca-prod"
    resource_group_key = "rg_network"

    bgp_route_propagation_enabled = true

    create = true
  }

  rt_app_vm = {

    name               = "rt-app-vm-prod"
    resource_group_key = "rg_network"

    bgp_route_propagation_enabled = true

    create = true
  }

  rt_database = {

    name               = "rt-database-prod"
    resource_group_key = "rg_network"

    bgp_route_propagation_enabled = true

    create = true
  }

  rt_storage = {

    name               = "rt-storage-prod"
    resource_group_key = "rg_network"

    bgp_route_propagation_enabled = true

    create = true
  }

  rt_pe = {

    name               = "rt-pe-prod"
    resource_group_key = "rg_network"

    bgp_route_propagation_enabled = true

    create = true
  }

  rt_data_vm = {

    name               = "rt-data-vm-prod"
    resource_group_key = "rg_network"

    bgp_route_propagation_enabled = true

    create = true
  }
}

# ============================================================================
# ROUTES
# ============================================================================

routes = {}

# ============================================================================
# ROUTE TABLE → SUBNET ASSOCIATIONS
# ============================================================================

route_table_subnet_associations = {

  container_apps_rt_subnet = {

    subnet_key      = "snet_container_app"
    route_table_key = "rt_container_apps"

    create = true
  }

  app_vm_rt_subnet = {

    subnet_key      = "snet_app_vm"
    route_table_key = "rt_app_vm"

    create = true
  }

  database_rt_subnet = {

    subnet_key      = "snet_database"
    route_table_key = "rt_database"

    create = true
  }

  storage_rt_subnet = {

    subnet_key      = "snet_storage"
    route_table_key = "rt_storage"

    create = true
  }

  pe_rt_subnet = {

    subnet_key      = "snet_pe"
    route_table_key = "rt_pe"

    create = true
  }

  data_vm_rt_subnet = {

    subnet_key      = "snet_data_vm"
    route_table_key = "rt_data_vm"

    create = true
  }
}

# ============================================================================
# PUBLIC IPs
# ============================================================================

public_ips = {

  pip_nat_prod = {

    name               = "pip-natgw-prod"
    resource_group_key = "rg_network"

    create = true
  }

  pip_appgw_prod = {
    name               = "pip-appgw-prod"
    resource_group_key = "rg_network"

    create = true
  }
}

# ============================================================================
# NAT GATEWAY
# ============================================================================

nat_gateways = {

  natgw_prod = {

    name               = "natgw-rewn-prod"
    resource_group_key = "rg_network"

    vnet_key      = "vnet_spoke_prod"
    public_ip_key = "pip_nat_prod"

    sku_name                = "Standard"
    idle_timeout_in_minutes = 10

    create = true
  }
}

# ============================================================================
# NAT GATEWAY → SUBNET ASSOCIATIONS
# ============================================================================

nat_gateway_subnet_associations = {

  natgw_container_app_subnet = {

    subnet_key      = "snet_container_app"
    nat_gateway_key = "natgw_prod"

    create = true
  }

  natgw_app_vm_subnet = {

    subnet_key      = "snet_app_vm"
    nat_gateway_key = "natgw_prod"

    create = true
  }

  natgw_database_subnet = {

    subnet_key      = "snet_database"
    nat_gateway_key = "natgw_prod"

    create = true
  }

  natgw_storage_subnet = {

    subnet_key      = "snet_storage"
    nat_gateway_key = "natgw_prod"

    create = true
  }

  natgw_pe_subnet = {

    subnet_key      = "snet_pe"
    nat_gateway_key = "natgw_prod"

    create = true
  }

  natgw_data_vm_subnet = {

    subnet_key      = "snet_data_vm"
    nat_gateway_key = "natgw_prod"

    create = true
  }
}

# ============================================================================
# VNET PEERING
# ============================================================================

vnet_peerings = {

  spoke_prod_hub = {

    spoke_vnet_key = "vnet_spoke_prod"
    hub_vnet_key   = "vnet_hub"

    spoke_to_hub_peering_name = "peer-spoke-prod-to-hub"
    hub_to_spoke_peering_name = "peer-hub-to-spoke-prod"

    allow_virtual_network_access = true
    allow_forwarded_traffic      = true

    # SPOKE → HUB
    spoke_to_hub_allow_gateway_transit = false
    spoke_to_hub_use_remote_gateways   = true

    # HUB → SPOKE
    hub_to_spoke_allow_gateway_transit = true
    hub_to_spoke_use_remote_gateways   = false

    create = false
  }
}

# ============================================================================
# AZURE BASTION
# ============================================================================

bastions = {}

# ============================================================================
# PRIVATE DNS ZONES
# ============================================================================
#
# DNS zones are owned by HUB STATE.
# PROD does NOT create these zones.
# ============================================================================

private_dns_zones = {}

# ============================================================================
# PRIVATE DNS ZONE → PROD VNET LINKS
# ============================================================================

private_dns_zone_links = {

  mysql_spoke = {

    name                 = "link-mysql-prod"
    resource_group_key   = "rg_network"
    private_dns_zone_key = "dns_mysql"
    vnet_key             = "vnet_spoke_prod"

    registration_enabled = false

    create = false
  }

  storage_spoke = {

    name                 = "link-storage-prod"
    resource_group_key   = "rg_network"
    private_dns_zone_key = "dns_storage"
    vnet_key             = "vnet_spoke_prod"

    registration_enabled = false

    create = false
  }

  redis_spoke = {

    name                 = "link-redis-prod"
    resource_group_key   = "rg_network"
    private_dns_zone_key = "dns_redis"
    vnet_key             = "vnet_spoke_prod"

    registration_enabled = false

    create = false
  }

  cosmos_dns_link = {

    name                 = "link-cosmos-prod"
    resource_group_key   = "rg_network"
    private_dns_zone_key = "dns_cosmos"
    vnet_key             = "vnet_spoke_prod"

    registration_enabled = false

    create = false
  }
}