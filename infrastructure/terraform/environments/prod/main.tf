# ============================================================================
# AZURE CLIENT CONFIG
# ============================================================================

data "azurerm_client_config" "current" {}


# ============================================================================
# RESOURCE GROUPS
# ============================================================================

module "resource_groups" {
  source = "../../modules/resource_groups"

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
# NETWORKING
# ============================================================================

module "networking" {
  source = "../../modules/networking"

  region       = var.region
  environment  = var.environment
  project_name = var.project_name
  tags         = var.tags

  # --------------------------------------------------------------------------
  # HUB VNET
  # --------------------------------------------------------------------------
  # Populate from hub remote state when required.
  # Currently no hub dependency is configured.
  # --------------------------------------------------------------------------

  hub_vnet_id = null

  hub_private_dns_zone_ids   = {}
  hub_private_dns_zone_names = {}

  # --------------------------------------------------------------------------
  # VNets
  # --------------------------------------------------------------------------

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

  # --------------------------------------------------------------------------
  # Subnets
  # --------------------------------------------------------------------------

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

  # --------------------------------------------------------------------------
  # Network Security Groups
  # --------------------------------------------------------------------------

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

  # --------------------------------------------------------------------------
  # Route Tables
  # --------------------------------------------------------------------------

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

  # --------------------------------------------------------------------------
  # Routes
  # --------------------------------------------------------------------------

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

  # --------------------------------------------------------------------------
  # Route Table → Subnet Associations
  # --------------------------------------------------------------------------

  route_table_subnet_associations = (
    var.route_table_subnet_associations
  )

  # --------------------------------------------------------------------------
  # Public IPs
  # --------------------------------------------------------------------------

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

  # --------------------------------------------------------------------------
  # NAT Gateways
  # --------------------------------------------------------------------------

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

  nat_gateway_subnet_associations = (
    var.nat_gateway_subnet_associations
  )

  # --------------------------------------------------------------------------
  # VNet Peerings
  # --------------------------------------------------------------------------

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

      hub_vnet_name           = null
      hub_resource_group_name = null

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

      spoke_to_hub_allow_gateway_transit = (
        peering.spoke_to_hub_allow_gateway_transit
      )

      spoke_to_hub_use_remote_gateways = (
        peering.spoke_to_hub_use_remote_gateways
      )

      hub_to_spoke_allow_gateway_transit = (
        peering.hub_to_spoke_allow_gateway_transit
      )

      hub_to_spoke_use_remote_gateways = (
        peering.hub_to_spoke_use_remote_gateways
      )

      create = peering.create
    }
  }

  # --------------------------------------------------------------------------
  # Azure Bastion
  # --------------------------------------------------------------------------

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

  # --------------------------------------------------------------------------
  # Private DNS Zones
  # --------------------------------------------------------------------------

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

  # --------------------------------------------------------------------------
  # Private DNS Zone → VNet Links
  # --------------------------------------------------------------------------

  private_dns_zone_links = {
    for key, link in var.private_dns_zone_links :
    key => {
      name = link.name

      resource_group_name = null

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


# ============================================================================
# STORAGE ACCOUNTS
# ============================================================================

module "storage_accounts" {
  source = "../../modules/storage"

  for_each = {
    for key, storage in var.storage_accounts :
    key => storage
    if storage.create
  }

  project_name = var.project_name

  storage_account_name = each.value.name

  resource_group_name = module.resource_groups[
    each.value.resource_group_key
  ].name

  location = var.region

  account_tier             = each.value.account_tier
  account_replication_type = each.value.account_replication_type
  access_tier              = each.value.access_tier

  https_traffic_only_enabled      = each.value.https_traffic_only_enabled
  public_network_access_enabled   = each.value.public_network_access_enabled
  allow_nested_items_to_be_public = each.value.allow_nested_items_to_be_public

  min_tls_version = each.value.min_tls_version

  environment = var.environment
  tags        = var.tags

  # --------------------------------------------------------------------------
  # Creation
  # --------------------------------------------------------------------------

  create_storage_account = true
  create_container       = false
  create_file_share      = false

  # --------------------------------------------------------------------------
  # RBAC
  # --------------------------------------------------------------------------

  assign_blob_data_reader = try(
    each.value.assign_blob_data_reader,
    false
  )

  # --------------------------------------------------------------------------
  # Private Endpoint
  # --------------------------------------------------------------------------

  create_private_endpoint = (
    try(each.value.private_endpoint.name, null) != null
  )

  private_endpoint_name = try(
    each.value.private_endpoint.name,
    null
  )

  private_endpoint_subresource_names = try(
    each.value.private_endpoint.subresource_names,
    []
  )

  private_endpoint_subnet_id = try(
    module.networking.subnet_ids[
      each.value.private_endpoint.subnet_key
    ],
    null
  )

  container_name = null
  share_name     = null
  share_quota    = null
}


# ============================================================================
# BLOB CONTAINERS
# ============================================================================

module "blob_containers" {
  source = "../../modules/storage"

  for_each = {
    for key, container in var.blob_containers :
    key => container
    if container.create
  }

  project_name = var.project_name

  # --------------------------------------------------------------------------
  # Storage Account
  # --------------------------------------------------------------------------

  storage_account_name = module.storage_accounts[
    each.value.storage_account_key
  ].storage_account_name

  resource_group_name = module.resource_groups[
    var.storage_accounts[
      each.value.storage_account_key
    ].resource_group_key
  ].name

  location = var.region

  environment = var.environment
  tags        = var.tags

  # --------------------------------------------------------------------------
  # Dummy Storage Settings
  # --------------------------------------------------------------------------

  account_tier             = "Standard"
  account_replication_type = "LRS"
  access_tier              = "Hot"

  https_traffic_only_enabled      = true
  public_network_access_enabled   = true
  allow_nested_items_to_be_public = false

  min_tls_version = "TLS1_2"

  # --------------------------------------------------------------------------
  # Creation
  # --------------------------------------------------------------------------

  create_storage_account = false
  create_container       = true
  create_file_share      = false
  create_private_endpoint = false

  # --------------------------------------------------------------------------
  # Container
  # --------------------------------------------------------------------------

  container_name        = each.value.name
  container_access_type = each.value.container_access_type

  # --------------------------------------------------------------------------
  # Unused
  # --------------------------------------------------------------------------

  share_name  = null
  share_quota = null

  private_endpoint_name              = null
  private_endpoint_subresource_names = []
  private_endpoint_subnet_id         = null
}


# ============================================================================
# AZURE FILE SHARES
# ============================================================================

module "file_shares" {
  source = "../../modules/storage"

  for_each = {
    for key, share in var.file_shares :
    key => share
    if share.create
  }

  project_name = var.project_name

  storage_account_name = module.storage_accounts[
    each.value.storage_account_key
  ].storage_account_name

  resource_group_name = module.resource_groups[
    var.storage_accounts[
      each.value.storage_account_key
    ].resource_group_key
  ].name

  location = var.region

  environment = var.environment
  tags        = var.tags

  # --------------------------------------------------------------------------
  # Dummy Storage Settings
  # --------------------------------------------------------------------------

  account_tier             = "Standard"
  account_replication_type = "LRS"
  access_tier              = "Hot"

  https_traffic_only_enabled      = true
  public_network_access_enabled   = true
  allow_nested_items_to_be_public = false

  min_tls_version = "TLS1_2"

  # --------------------------------------------------------------------------
  # Creation
  # --------------------------------------------------------------------------

  create_storage_account  = false
  create_container        = false
  create_file_share       = true
  create_private_endpoint = false

  # --------------------------------------------------------------------------
  # File Share
  # --------------------------------------------------------------------------

  share_name  = each.value.name
  share_quota = each.value.quota

  # --------------------------------------------------------------------------
  # Unused
  # --------------------------------------------------------------------------

  container_name        = null
  container_access_type = "private"

  private_endpoint_name              = null
  private_endpoint_subresource_names = []
  private_endpoint_subnet_id         = null
}


# ============================================================================
# SECURITY
# ============================================================================

module "security" {
  source = "../../modules/security"

  # --------------------------------------------------------------------------
  # Key Vault
  # --------------------------------------------------------------------------

  key_vault_name = var.key_vaults["primary"].name

  location = var.region

  resource_group_name = module.resource_groups[
    "rg_security"
  ].name

  tenant_id = data.azurerm_client_config.current.tenant_id

  sku_name = var.key_vaults[
    "primary"
  ].sku

  purge_protection_enabled = var.key_vaults[
    "primary"
  ].purge_protection_enabled

  soft_delete_retention_days = var.key_vaults[
    "primary"
  ].soft_delete_retention_days

  enable_rbac_authorization = var.key_vaults[
    "primary"
  ].enable_rbac_authorization

  # --------------------------------------------------------------------------
  # Common
  # --------------------------------------------------------------------------

  environment = var.environment
  tags        = var.tags

  # --------------------------------------------------------------------------
  # Key Vault Secrets
  #
  # Secrets will be created manually in Azure Key Vault.
  # Terraform will NOT manage password values.
  # --------------------------------------------------------------------------

  key_vault_secrets = {}

  # --------------------------------------------------------------------------
  # Managed Identities
  # --------------------------------------------------------------------------

  managed_identities = var.managed_identities

  # --------------------------------------------------------------------------
  # Federated Credentials
  # --------------------------------------------------------------------------

  federated_credentials = var.federated_identity_credentials

  # --------------------------------------------------------------------------
  # Role Assignments
  # --------------------------------------------------------------------------

  role_assignments = var.role_assignments
}


# ============================================================================
# MYSQL FLEXIBLE SERVER
# ============================================================================

module "mysql_servers" {
  source = "../../modules/mysql"

  for_each = {
    for key, mysql in var.mysql_servers :
    key => mysql
    if mysql.create
  }

  # --------------------------------------------------------------------------
  # Basic Configuration
  # --------------------------------------------------------------------------

  name = each.value.name

  resource_group_name = module.resource_groups[
    each.value.resource_group_key
  ].name

  location = coalesce(
    var.mysql_region,
    var.region
  )

  sku_name = each.value.sku_name

  mysql_version = each.value.version

  storage_gb = each.value.storage_gb

  zone = each.value.zone

  # --------------------------------------------------------------------------
  # Backup
  # --------------------------------------------------------------------------

  backup_retention_days = (
    each.value.backup_retention_days
  )

  geo_redundant_backup_enabled = (
    each.value.geo_redundant_backup_enabled
  )

  # --------------------------------------------------------------------------
  # Storage
  # --------------------------------------------------------------------------

  auto_grow_enabled = each.value.auto_grow_enabled

  # --------------------------------------------------------------------------
  # Administrator
  # --------------------------------------------------------------------------

  administrator_login = (
    each.value.administrator_login
  )

  administrator_password = (
    var.mysql_administrator_password
  )

  # --------------------------------------------------------------------------
  # MySQL Configuration
  # --------------------------------------------------------------------------

  configurations = each.value.configurations

  # --------------------------------------------------------------------------
  # Private Endpoint
  #
  # Centralized private_endpoints module manages PE.
  # --------------------------------------------------------------------------

  create_private_endpoint = false

  private_endpoint_name              = null
  private_endpoint_subresource_names = []
  private_endpoint_subnet_id         = null

  # --------------------------------------------------------------------------
  # Common
  # --------------------------------------------------------------------------

  environment  = var.environment
  project_name = var.project_name
  tags         = var.tags
}


# ============================================================================
# COSMOS DB - MONGODB API
# ============================================================================

module "cosmos_mongo" {
  source = "../../modules/cosmosdb"

  for_each = {
    for key, cosmos in var.cosmos_mongo_accounts :
    key => cosmos
    if cosmos.create
  }

  name = each.value.name

  resource_group_name = module.resource_groups[
    each.value.resource_group_key
  ].name

  location = var.region

  kind = "MongoDB"

  mongo_server_version = (
    each.value.mongo_server_version
  )

  enable_automatic_failover = (
    each.value.enable_automatic_failover
  )

  enable_multiple_write_locations = (
    each.value.enable_multiple_write_locations
  )

  consistency_level = (
    each.value.consistency_level
  )

  geo_locations = each.value.geo_locations

  mongo_databases   = each.value.mongo_databases
  mongo_collections = each.value.mongo_collections

  environment  = var.environment
  project_name = var.project_name
  tags         = var.tags
}


# ============================================================================
# COSMOS DB - NOSQL
# ============================================================================

module "cosmos_nosql" {
  source = "../../modules/cosmosdb"

  for_each = {
    for key, cosmos in var.cosmos_nosql_accounts :
    key => cosmos
    if cosmos.create
  }

  name = each.value.name

  resource_group_name = module.resource_groups[
    each.value.resource_group_key
  ].name

  location = var.region

  kind = "GlobalDocumentDB"

  enable_automatic_failover = (
    each.value.enable_automatic_failover
  )

  enable_multiple_write_locations = (
    each.value.enable_multiple_write_locations
  )

  consistency_level = (
    each.value.consistency_level
  )

  geo_locations = each.value.geo_locations

  sql_databases  = each.value.sql_databases
  sql_containers = each.value.sql_containers

  environment  = var.environment
  project_name = var.project_name
  tags         = var.tags
}


# ============================================================================
# CENTRALIZED PRIVATE ENDPOINTS
# ============================================================================

module "private_endpoints" {
  source = "../../modules/private_endpoints"

  for_each = {
    for key, pe in var.private_endpoints :
    key => pe
    if pe.create
  }

  name = each.value.name

  resource_group_name = module.resource_groups[
    each.value.resource_group
  ].name

  location = var.region

  subnet_id = module.networking.subnet_ids[
    each.value.subnet_name
  ]

  private_connection_resource_id = (
    each.value.service_type == "mysqlServer"
    ? module.mysql_servers[
        each.value.service_name
      ].id

    : each.value.service_type == "cosmosdb"
    ? (
        try(
          module.cosmos_mongo[
            each.value.service_name
          ].id,
          null
        ) != null
        ? module.cosmos_mongo[
            each.value.service_name
          ].id
        : module.cosmos_nosql[
            each.value.service_name
          ].id
      )

    : null
  )

  subresource_names = (
    each.value.subresource_names
  )

  environment  = var.environment
  project_name = var.project_name
  tags         = var.tags
}


# ============================================================================
# CONTAINER APP ENVIRONMENT
# ============================================================================

resource "azurerm_container_app_environment" "main" {
  name = "${var.project_name}-${var.environment}-aca-env"

  resource_group_name = module.resource_groups[
    "rg_app"
  ].name

  location = var.region

  tags = merge(
    var.tags,
    {
      Environment = var.environment
      Project     = var.project_name
    }
  )
}


# ============================================================================
# CONTAINER APPS
# ============================================================================

module "container_apps" {
  source = "../../modules/container_apps"

  for_each = {
    for key, app in var.container_apps :
    key => app
    if app.create
  }

  name = each.value.name

  container_name = each.value.container_name

  resource_group_name = module.resource_groups[
    each.value.resource_group_key
  ].name

  container_app_environment_id = (
    azurerm_container_app_environment.main.id
  )

  image = each.value.image

  cpu    = each.value.cpu
  memory = each.value.memory

  revision_mode = each.value.revision_mode

  min_replicas = each.value.min_replicas
  max_replicas = each.value.max_replicas

  environment_variables = (
    each.value.environment_variables
  )

  managed_identity_id = try(
    module.security.managed_identity_ids[
      "container_apps"
    ],
    null
  )

  ingress = each.value.ingress

  http_scale_rule = try(
    each.value.http_scale_rule,
    null
  )

  environment  = var.environment
  project_name = var.project_name
  tags         = var.tags
}


# ============================================================================
# APPLICATION GATEWAY WAF POLICY
# ============================================================================

resource "azurerm_web_application_firewall_policy" "application_gateway" {
  name = "waf-${var.project_name}-${var.environment}"

  resource_group_name = module.resource_groups[
    "rg_network"
  ].name

  location = var.region

  policy_settings {
    enabled                     = true
    mode                        = "Prevention"
    request_body_check          = true
    file_upload_limit_in_mb     = 100
    max_request_body_size_in_kb = 128
  }

  managed_rules {
    managed_rule_set {
      type    = "OWASP"
      version = "3.2"
    }
  }

  tags = merge(
    var.tags,
    {
      Environment = var.environment
      Project     = var.project_name
    }
  )
}


# ============================================================================
# APPLICATION GATEWAY
# ============================================================================

module "application_gateway" {
  source = "../../modules/application_gateway"

  application_gateways = {
    for key, gateway in var.application_gateways :
    key => merge(
      gateway,
      {
        firewall_policy_id = (
          azurerm_web_application_firewall_policy
          .application_gateway.id
        )

        resource_group_name = module.resource_groups[
          gateway.resource_group_key
        ].name

        subnet_id = module.networking.subnet_ids[
          gateway.subnet_key
        ]

        public_ip_address_id = module.networking.public_ip_ids[
          gateway.public_ip_key
        ]

        managed_identity_id = try(
          module.security.managed_identity_ids[
            gateway.managed_identity_key
          ],
          null
        )
      }
    )
  }

  location     = var.region
  environment  = var.environment
  project_name = var.project_name
  tags         = var.tags
}