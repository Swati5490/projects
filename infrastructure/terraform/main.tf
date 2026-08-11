# Main Terraform Configuration for REWN Infrastructure
# This file orchestrates all modules for Azure resource deployment

# Data source to get current Azure context
data "azurerm_client_config" "current" {}

# Resource Groups Module
module "resource_groups" {
  source = "./modules/resource_group"

  for_each = var.resource_groups

  resource_group_name = each.value.name
  location            = var.region
  environment         = var.environment
  project_name        = var.project_name
  tags                = var.tags
}

# Networking Module
module "networking" {
  source = "./modules/networking"

  for_each = var.vnets

  vnet_name               = each.value.name
  location                = var.region
  resource_group_name     = module.resource_groups["network"].name
  address_space           = each.value.address_space
  dns_servers             = each.value.dns_servers
  environment             = var.environment
  project_name            = var.project_name
  tags                    = var.tags

  depends_on = [module.resource_groups]
}

# Subnets Module
module "subnets" {
  source = "./modules/networking"

  for_each = var.subnets

  subnet_name             = each.value.name
  vnet_name               = each.value.vnet_name
  location                = var.region
  resource_group_name     = module.resource_groups["network"].name
  address_prefixes        = each.value.address_prefixes
  service_endpoints       = each.value.service_endpoints
  environment             = var.environment
  project_name            = var.project_name
  tags                    = var.tags

  depends_on = [module.networking]
}

# Network Security Groups Module
module "network_security_groups" {
  source = "./modules/networking"

  for_each = var.network_security_groups

  nsg_name            = each.value.name
  location            = var.region
  resource_group_name = module.resource_groups[lookup(each.value, "resource_group", "network")].name
  environment         = var.environment
  project_name        = var.project_name
  tags                = var.tags

  depends_on = [module.resource_groups]
}

# Advanced Networking Resources - VNet Peering, Route Tables, NAT Gateways, Bastion, Private DNS Zones
module "advanced_networking" {
  source = "./modules/networking"

  # Pass all VNet/subnet names first
  # For prod: use hub vnet, for dev: use null
  vnet_name           = var.environment == "prod" ? "vnet-hub-rewn-prod-cin" : null
  subnet_name         = null
  nsg_name            = null
  location            = var.region
  resource_group_name = module.resource_groups["network"].name
  environment         = var.environment
  project_name        = var.project_name
  tags                = var.tags

  # Pass all advanced networking resources
  vnet_peerings      = var.vnet_peerings
  route_tables       = var.route_tables
  routes             = var.routes
  nat_gateways       = var.nat_gateways
  public_ips         = var.public_ips
  bastions           = var.bastions
  private_dns_zones  = var.private_dns_zones

  depends_on = [module.resource_groups, module.networking, module.subnets]
}

# Application Gateway Module - Shared Entry Point
module "application_gateway" {
  source = "./modules/application_gateway"

  for_each = var.application_gateways

  appgw_name              = each.value.name
  resource_group_name     = module.resource_groups["network"].name
  location                = var.region
  environment             = var.environment
  project_name            = var.project_name
  tags                    = var.tags
  sku_name                = each.value.sku_name
  sku_tier                = each.value.sku_tier
  capacity                = each.value.capacity
  public_ip_name          = each.value.public_ip_name
  enable_waf              = each.value.enable_waf
  backend_address_pools   = each.value.backend_pools
  http_settings           = each.value.http_settings
  http_listeners          = each.value.http_listeners
  request_routing_rules   = each.value.request_routing_rules
  subnet_id               = module.subnets["appgw"].subnet_id
  zones                   = each.value.zones

  depends_on = [module.resource_groups, module.subnets, module.network_security_groups]
}

# Front Door Module - Global Entry Point
module "front_door" {
  source = "./modules/front_door"

  for_each = var.front_doors

  front_door_name     = each.value.name
  resource_group_name = module.resource_groups["network"].name
  location            = var.region
  environment         = var.environment
  project_name        = var.project_name
  tags                = var.tags
  sku_name            = each.value.sku_name
  enforce_https       = each.value.enforce_https
  http_to_https_redirect = each.value.http_to_https_redirect
  enable_waf          = each.value.enable_waf
  waf_policy_mode     = each.value.waf_policy_mode
  backend_pools       = each.value.backend_pools
  frontend_endpoints  = each.value.frontend_endpoints
  routing_rules       = each.value.routing_rules

  depends_on = [module.resource_groups, module.application_gateway]
}

# Storage Module
module "storage" {
  source = "./modules/storage"

  for_each = var.storage_accounts

  storage_account_name       = each.value.name
  resource_group_name        = module.resource_groups["storage"].name
  location                   = var.region
  account_tier               = each.value.account_tier
  account_replication_type   = each.value.account_replication_type
  access_tier                = each.value.access_tier
  https_traffic_only_enabled = each.value.https_traffic_only_enabled
  min_tls_version            = each.value.min_tls_version
  blob_delete_retention      = each.value.blob_delete_retention
  versioning_enabled         = each.value.versioning_enabled
  environment                = var.environment
  project_name               = var.project_name
  tags                       = var.tags

  depends_on = [module.resource_groups]
}

# Blob Containers Module
module "blob_containers" {
  source = "./modules/storage"

  for_each = var.blob_containers

  container_name            = each.value.name
  storage_account_name      = each.value.storage_account_name
  container_access_type     = each.value.container_access_type
  resource_group_name       = module.resource_groups["storage"].name
  location                  = var.region
  environment               = var.environment
  project_name              = var.project_name
  tags                      = var.tags

  depends_on = [module.storage]
}

# Azure File Shares Module
module "file_shares" {
  source = "./modules/storage"

  for_each = var.file_shares

  share_name           = each.value.name
  storage_account_name = each.value.storage_account_name
  share_quota          = each.value.quota
  resource_group_name  = module.resource_groups["storage"].name
  location             = var.region
  environment          = var.environment
  project_name         = var.project_name
  tags                 = var.tags

  depends_on = [module.storage]
}

# Function Apps Module
module "function_apps" {
  source = "./modules/functions"

  for_each = var.function_apps

  function_app_name         = each.value.name
  resource_group_name       = module.resource_groups["compute"].name
  location                  = var.region
  sku_name                  = each.value.sku_name
  runtime                   = each.value.runtime
  storage_account_name      = each.value.storage_account_name
  environment               = var.environment
  project_name              = var.project_name
  tags                      = var.tags

  depends_on = [module.storage]
}

# Functions Module (Timer-triggered)
module "functions" {
  source = "./modules/functions"

  for_each = var.functions

  function_name       = each.value.name
  function_app_id     = module.function_apps[each.value.function_app_name].function_app_id
  function_app_name   = each.value.function_app_name
  location            = var.region
  resource_group_name = module.resource_groups["compute"].name
  runtime             = each.value.runtime
  schedule            = each.value.schedule
  script_file         = each.value.script_file
  environment         = var.environment
  project_name        = var.project_name
  tags                = var.tags

  depends_on = [module.function_apps]
}

# Databases Module - MySQL
module "mysql_servers" {
  source = "./modules/databases"

  for_each = var.mysql_servers

  server_name                 = each.value.name
  resource_group_name         = module.resource_groups["databases"].name
  location                    = var.region
  sku_name                    = each.value.sku_name
  storage_gb                  = each.value.storage_gb
  backup_retention_days       = each.value.backup_retention_days
  geo_redundant_backup_enabled = each.value.geo_redundant_backup_enabled
  zone                        = each.value.zone
  auto_grow_enabled           = each.value.auto_grow_enabled
  administrator_login         = each.value.administrator_login
  environment                 = var.environment
  project_name                = var.project_name
  tags                        = var.tags

  depends_on = [module.resource_groups]
}

# Databases Module - Cosmos DB
module "cosmosdb_accounts" {
  source = "./modules/databases"

  for_each = var.cosmosdb_accounts

  cosmosdb_account_name          = each.value.name
  resource_group_name            = module.resource_groups["databases"].name
  location                       = var.region
  offer_type                     = each.value.offer_type
  kind                           = each.value.kind
  enable_automatic_failover      = each.value.enable_automatic_failover
  enable_multiple_write_locations = each.value.enable_multiple_write_locations
  consistency_level              = each.value.consistency_level
  environment                    = var.environment
  project_name                   = var.project_name
  tags                           = var.tags

  depends_on = [module.resource_groups]
}

# Databases Module - Redis
module "redis_caches" {
  source = "./modules/databases"

  for_each = var.redis_caches

  redis_cache_name     = each.value.name
  resource_group_name  = module.resource_groups["databases"].name
  location             = var.region
  capacity             = each.value.capacity
  family               = each.value.family
  redis_sku_name       = each.value.sku_name
  enable_non_ssl       = each.value.enable_non_ssl
  minimum_tls_version  = each.value.minimum_tls_version
  zones                = each.value.zones
  environment          = var.environment
  project_name         = var.project_name
  tags                 = var.tags

  depends_on = [module.resource_groups]
}

# Compute Module - AKS
module "aks_clusters" {
  source = "./modules/compute"

  for_each = var.aks_clusters

  cluster_name                = each.value.name
  resource_group_name         = module.resource_groups["compute"].name
  location                    = var.region
  kubernetes_version          = each.value.kubernetes_version
  default_node_pool_name      = each.value.default_node_pool_name
  default_node_pool_count     = each.value.default_node_pool_count
  default_node_pool_vm_size   = each.value.default_node_pool_vm_size
  network_plugin              = each.value.network_plugin
  network_policy              = each.value.network_policy
  load_balancer_sku           = each.value.load_balancer_sku
  zones                       = each.value.zones
  environment                 = var.environment
  project_name                = var.project_name
  tags                        = var.tags

  depends_on = [module.resource_groups]
}

# Compute Module - Azure Container Registry
module "container_registries" {
  source = "./modules/container_registry"

  for_each = var.container_registries

  registry_name                    = each.value.name
  resource_group_name              = module.resource_groups["compute"].name
  location                         = var.region
  sku                              = each.value.sku
  admin_enabled                    = each.value.admin_enabled
  public_network_access_enabled    = each.value.public_network_access_enabled
  zone_redundancy_enabled          = each.value.zone_redundancy_enabled
  export_policy_enabled            = each.value.export_policy_enabled
  data_endpoint_enabled            = each.value.data_endpoint_enabled
  network_rule_bypass_option       = each.value.network_rule_bypass_option
  anonymous_pull_enabled           = each.value.anonymous_pull_enabled
  encryption_enabled               = each.value.encryption_enabled
  identity_type                    = each.value.identity_type
  quarantine_policy_enabled        = each.value.quarantine_policy_enabled
  retention_policy_days            = each.value.retention_policy_days
  trust_policy_enabled             = each.value.trust_policy_enabled
  aks_principal_id                 = try(module.aks_clusters["primary"].kubelet_identity_principal_id, null)
  environment                      = var.environment
  project_name                     = var.project_name
  tags                             = var.tags

  depends_on = [module.resource_groups, module.aks_clusters]
}

# Security Module - Key Vault
module "key_vaults" {
  source = "./modules/security"

  for_each = var.key_vaults

  key_vault_name              = each.value.name
  resource_group_name         = module.resource_groups["security"].name
  location                    = var.region
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = each.value.sku
  purge_protection_enabled    = each.value.purge_protection_enabled
  soft_delete_retention_days  = each.value.soft_delete_retention_days
  enable_rbac_authorization   = each.value.enable_rbac_authorization
  environment                 = var.environment
  project_name                = var.project_name
  tags                        = var.tags

  depends_on = [module.resource_groups]
}

# Monitoring Module
module "monitoring" {
  source = "./modules/monitoring"

  environment     = var.environment
  project_name    = var.project_name
  region          = var.region
  resource_groups = module.resource_groups
  tags            = var.tags

  depends_on = [module.resource_groups]
}

# Backup Module
module "backup" {
  source = "./modules/backup"

  environment     = var.environment
  project_name    = var.project_name
  region          = var.region
  resource_groups = module.resource_groups
  tags            = var.tags

  depends_on = [module.resource_groups]
}
