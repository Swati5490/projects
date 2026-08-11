variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
}

variable "environment" {
  description = "Environment name (prod, dev, staging)"
  type        = string
  validation {
    condition     = contains(["prod", "dev", "staging"], var.environment)
    error_message = "Environment must be prod, dev, or staging."
  }
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
  default     = "rewn"
}

variable "region" {
  description = "Azure region"
  type        = string
  default     = "centralindia"
}

variable "region_short" {
  description = "Azure region short code"
  type        = string
  default     = "cin"
}

variable "tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default = {
    ManagedBy   = "Terraform"
    Project     = "REWN"
    CreatedDate = "2026-08-05"
  }
}

# Resource Group Configuration
variable "resource_groups" {
  description = "List of resource groups to create"
  type = map(object({
    name    = string
    purpose = string
  }))
}

# Networking Configuration
variable "vnets" {
  description = "Virtual Networks configuration"
  type = map(object({
    name          = string
    address_space = list(string)
    environment   = string
    dns_servers   = optional(list(string))
  }))
}

variable "subnets" {
  description = "Subnets configuration"
  type = map(object({
    name                = string
    vnet_name           = string
    address_prefixes    = list(string)
    service_endpoints   = optional(list(string))
    delegation          = optional(string)
    nsg_association     = optional(string)
  }))
}

variable "network_security_groups" {
  description = "Network Security Groups configuration"
  type = map(object({
    name                = string
    priority            = optional(number)
    direction           = optional(string)
    access              = optional(string)
    protocol            = optional(string)
    source_port_range   = optional(string)
    dest_port_range     = optional(string)
    source_address      = optional(list(string))
    destination_address = optional(list(string))
  }))
}

# VNet Peering Configuration
variable "vnet_peerings" {
  description = "VNet peering configuration"
  type = map(object({
    name                             = string
    source_vnet_name                 = string
    source_vnet_rg                   = string
    destination_vnet_name            = string
    destination_vnet_rg              = string
    allow_virtual_network_access     = optional(bool, true)
    allow_forwarded_traffic          = optional(bool, true)
    allow_gateway_transit            = optional(bool, true)
    use_remote_gateways              = optional(bool, false)
  }))
  default = {}
}

# Route Tables Configuration
variable "route_tables" {
  description = "Route tables configuration"
  type = map(object({
    name = string
  }))
  default = {}
}

# Routes Configuration
variable "routes" {
  description = "Routes configuration"
  type = map(object({
    name                   = string
    route_table_name       = string
    address_prefix         = string
    next_hop_type          = string
    next_hop_in_ip_address = optional(string)
  }))
  default = {}
}

# NAT Gateways Configuration
variable "nat_gateways" {
  description = "NAT gateways configuration"
  type = map(object({
    name           = string
    public_ip_name = string
    idle_timeout   = optional(number, 4)
    zones          = optional(list(string), [])
  }))
  default = {}
}

# Public IPs Configuration
variable "public_ips" {
  description = "Public IPs configuration"
  type = map(object({
    name              = string
    allocation_method = optional(string, "Static")
    sku               = optional(string, "Standard")
    zones             = optional(list(string), [])
  }))
  default = {}
}

# Azure Bastion Configuration
variable "bastions" {
  description = "Azure Bastion configuration"
  type = map(object({
    name                   = string
    public_ip_name         = string
    subnet_name            = string
    tunneling_enabled      = optional(bool, false)
    ip_connect_enabled     = optional(bool, false)
    shareable_link_enabled = optional(bool, false)
  }))
  default = {}
}

# Private DNS Zones Configuration
variable "private_dns_zones" {
  description = "Private DNS zones configuration"
  type = map(object({
    name = string
  }))
  default = {}
}

# Application Gateway Configuration
variable "application_gateways" {
  description = "Application Gateway configuration"
  type = map(object({
    name                = string
    sku_name            = optional(string, "Standard_v2")
    sku_tier            = optional(string, "Standard")
    capacity            = optional(number, 2)
    public_ip_name      = optional(string)
    enable_waf          = optional(bool, false)
    waf_mode            = optional(string, "Detection")
    backend_pools       = optional(map(any), {})
    http_settings       = optional(map(any), {})
    http_listeners      = optional(map(any), {})
    request_routing_rules = optional(map(any), {})
    zones               = optional(list(string), [])
  }))
  default = {}
}

# Front Door Configuration
variable "front_doors" {
  description = "Front Door configuration"
  type = map(object({
    name                 = string
    sku_name             = optional(string, "Standard_AzureFrontDoor")
    enforce_https        = optional(bool, true)
    http_to_https_redirect = optional(bool, true)
    enable_waf           = optional(bool, false)
    waf_policy_mode      = optional(string, "Detection")
    backend_pools        = optional(map(any), {})
    frontend_endpoints   = optional(map(any), {})
    routing_rules        = optional(map(any), {})
  }))
  default = {}
}

# Storage Configuration
variable "storage_accounts" {
  description = "Storage accounts configuration"
  type = map(object({
    name                      = string
    account_tier              = optional(string, "Standard")
    account_replication_type  = optional(string, "GRS")
    access_tier               = optional(string, "Hot")
    https_traffic_only_enabled = optional(bool, true)
    min_tls_version           = optional(string, "TLS1_2")
    blob_delete_retention     = optional(number, 7)
    versioning_enabled        = optional(bool, true)
  }))
}

variable "blob_containers" {
  description = "Blob containers configuration"
  type = map(object({
    name                  = string
    storage_account_name  = string
    container_access_type = optional(string, "private")
  }))
}

variable "file_shares" {
  description = "Azure File Shares configuration"
  type = map(object({
    name                  = string
    storage_account_name  = string
    quota                 = optional(number, 100)
  }))
  default = {}
}

# Functions Configuration
variable "function_apps" {
  description = "Azure Function Apps configuration"
  type = map(object({
    name                  = string
    sku_name              = optional(string, "Y1")
    runtime               = optional(string, "python")
    storage_account_name  = string
  }))
  default = {}
}

variable "functions" {
  description = "Azure Functions (Timer-triggered) configuration"
  type = map(object({
    name              = string
    function_app_name = string
    runtime           = optional(string, "python")
    schedule          = optional(string, "0 0 * * * *")
    script_file       = optional(string, "main.py")
    purpose           = optional(string)
  }))
  default = {}
}

# Database Configuration
variable "mysql_servers" {
  description = "Azure Database for MySQL Flexible Servers"
  type = map(object({
    name                          = string
    sku_name                      = optional(string, "B_Standard_B1s")
    storage_gb                    = optional(number, 20)
    backup_retention_days         = optional(number, 7)
    geo_redundant_backup_enabled  = optional(bool, true)
    zone                          = optional(string)
    auto_grow_enabled             = optional(bool, true)
    administrator_login           = optional(string)
    version                       = optional(string, "8.0.21")
  }))
}

variable "cosmosdb_accounts" {
  description = "Cosmos DB accounts configuration"
  type = map(object({
    name                       = string
    offer_type                 = optional(string, "Standard")
    kind                       = optional(string, "MongoDB")
    enable_automatic_failover  = optional(bool, true)
    enable_multiple_write_locations = optional(bool, false)
    consistency_level          = optional(string, "Session")
  }))
}

variable "redis_caches" {
  description = "Azure Cache for Redis configuration"
  type = map(object({
    name              = string
    capacity          = optional(number, 1)
    family            = optional(string, "C")
    sku_name          = optional(string, "Standard")
    enable_non_ssl    = optional(bool, false)
    minimum_tls_version = optional(string, "1.2")
    zones             = optional(list(string))
  }))
}

# Compute Configuration
variable "aks_clusters" {
  description = "AKS clusters configuration"
  type = map(object({
    name                    = string
    kubernetes_version      = optional(string, "1.28")
    default_node_pool_name  = optional(string, "systempool")
    default_node_pool_count = optional(number, 3)
    default_node_pool_vm_size = optional(string, "Standard_D2s_v3")
    network_plugin          = optional(string, "azure")
    network_policy          = optional(string, "azure")
    load_balancer_sku       = optional(string, "standard")
    zones                   = optional(list(string), ["1", "2", "3"])
  }))
}

# Container Registry Configuration
variable "container_registries" {
  description = "Azure Container Registry configuration"
  type = map(object({
    name                         = string
    sku                          = optional(string, "Premium")
    admin_enabled                = optional(bool, false)
    public_network_access_enabled = optional(bool, false)
    zone_redundancy_enabled      = optional(bool, true)
    export_policy_enabled        = optional(bool, true)
    data_endpoint_enabled        = optional(bool, false)
    network_rule_bypass_option   = optional(string, "AzureServices")
    anonymous_pull_enabled       = optional(bool, false)
    encryption_enabled           = optional(bool, false)
    identity_type                = optional(string, "SystemAssigned")
    quarantine_policy_enabled    = optional(bool, false)
    retention_policy_days        = optional(number, 30)
    trust_policy_enabled         = optional(bool, false)
  }))
  default = {}
}

# Key Vault Configuration
variable "key_vaults" {
  description = "Key Vault configuration"
  type = map(object({
    name                            = string
    sku                             = optional(string, "standard")
    purge_protection_enabled        = optional(bool, true)
    soft_delete_retention_days      = optional(number, 90)
    enable_rbac_authorization       = optional(bool, true)
  }))
}

# Backup Configuration
variable "recovery_services_vaults" {
  description = "Recovery Services Vault configuration"
  type = map(object({
    name                  = string
    sku                   = optional(string, "Standard")
    storage_mode_type     = optional(string, "GeoRedundant")
  }))
  default = {}
}

variable "backup_policies" {
  description = "Backup policies for VMs"
  type = map(object({
    name                  = string
    policy_type           = optional(string, "V2")
    timezone              = optional(string, "UTC")
    backup_frequency      = optional(string, "Daily")
    backup_time           = optional(string, "04:00")
    retention_daily_count = optional(number, 7)
    retention_monthly_count = optional(number, 12)
    retention_yearly_count = optional(number, 7)
  }))
  default = {}
}

# Monitoring Configuration
variable "log_analytics_workspaces" {
  description = "Log Analytics Workspace configuration"
  type = map(object({
    name              = string
    sku               = optional(string, "PerGB2018")
    retention_in_days = optional(number, 30)
    daily_quota_gb    = optional(number, 10)
  }))
  default = {}
}

variable "app_insights" {
  description = "Application Insights configuration"
  type = map(object({
    name              = string
    application_type  = optional(string, "web")
    retention_in_days = optional(number, 30)
  }))
  default = {}
}

variable "action_groups" {
  description = "Action Groups configuration"
  type = map(object({
    name                    = string
    short_name              = optional(string)
    email_receivers         = optional(map(any), {})
    sms_receivers           = optional(map(any), {})
    webhook_receivers       = optional(map(any), {})
  }))
  default = {}
}

# Private Endpoints Configuration
variable "private_endpoints" {
  description = "Private Endpoints configuration"
  type = map(object({
    name                = string
    service_name        = string
    service_type        = string
    subresource_names   = list(string)
    subnet_name         = string
    resource_group      = optional(string, "network")
  }))
  default = {}
}

# Key Vault Secrets Configuration
variable "key_vault_secrets" {
  description = "Key Vault Secrets configuration"
  type = map(object({
    name            = string
    value           = string
    key_vault       = string
    content_type    = optional(string)
    tags            = optional(map(string), {})
  }))
  default = {}
  sensitive = true
}

# Managed Identities Configuration
variable "managed_identities" {
  description = "Managed Identities configuration"
  type = map(object({
    name = string
  }))
  default = {}
}

# Diagnostic Settings Configuration
variable "diagnostic_settings" {
  description = "Diagnostic Settings configuration"
  type = map(object({
    name                       = string
    target_resource_id         = string
    target_resource_type       = string
    log_analytics_workspace_id = string
    logs_enabled              = optional(bool, true)
    metrics_enabled           = optional(bool, true)
  }))
  default = {}
}

# Metric Alert Rules Configuration
variable "metric_alert_rules" {
  description = "Metric Alert Rules configuration"
  type = map(object({
    name                = string
    resource_group      = string
    scopes             = list(string)
    metric_name        = string
    operator           = string
    threshold          = number
    aggregation        = string
    window_size        = string
    frequency          = string
    action_group       = string
  }))
  default = {}
}

# Database Migration Service Configuration
variable "database_migration_services" {
  description = "Database Migration Services configuration"
  type = map(object({
    name            = string
    sku_name        = string
    location        = string
    virtual_network = string
    subnet          = string
  }))
  default = {}
}

# Migration Projects Configuration
variable "migration_projects" {
  description = "Migration Projects configuration"
  type = map(object({
    name                  = string
    service_name          = string
    source_platform       = string
    target_platform       = string
    migration_type        = string
    source_connection_info = map(string)
    target_connection_info = map(string)
  }))
  default = {}
  sensitive = true
}

# Count Configuration
variable "resource_counts" {
  description = "Control how many of each resource type to create"
  type = object({
    resource_groups         = number
    vnets                   = number
    subnets                 = number
    storage_accounts        = number
    blob_containers         = number
    mysql_servers           = number
    aks_clusters            = number
    nsgs                    = number
  })
  default = {
    resource_groups         = 1
    vnets                   = 1
    subnets                 = 1
    storage_accounts        = 1
    blob_containers         = 1
    mysql_servers           = 1
    aks_clusters            = 1
    nsgs                    = 1
  }
}

# Cost Tracking
variable "cost_center" {
  description = "Cost center for billing"
  type        = string
  default     = "engineering"
}

variable "owner" {
  description = "Resource owner email"
  type        = string
  default     = "infra-team@rewn.io"
}
