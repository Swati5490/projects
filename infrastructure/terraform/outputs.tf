# Output values for Terraform modules

output "resource_groups" {
  description = "Created resource groups"
  value = {
    for name, rg in module.resource_groups :
    name => {
      id       = rg.id
      name     = rg.name
      location = rg.location
    }
  }
}

output "vnets" {
  description = "Created Virtual Networks"
  value = {
    for name, vnet in module.networking :
    name => {
      id            = vnet.vnet_id
      name          = vnet.vnet_name
      address_space = vnet.address_space
    }
  }
  sensitive = false
}

output "storage_accounts" {
  description = "Created Storage Accounts"
  value = {
    for name, sa in module.storage :
    name => {
      id                  = sa.storage_account_id
      name                = sa.storage_account_name
      primary_blob_endpoint = sa.primary_blob_endpoint
      access_key          = "Use terraform state or Key Vault for actual key"
    }
  }
  sensitive = false
}

output "file_shares" {
  description = "Created Azure File Shares"
  value = {
    for name, share in module.file_shares :
    name => {
      name                  = share.file_share_name
      storage_account_name  = share.file_share_storage_account_name
      quota                 = share.file_share_quota
    }
  }
  sensitive = false
}

output "function_apps" {
  description = "Created Azure Function Apps"
  value = {
    for name, app in module.function_apps :
    name => {
      id               = app.function_app_id
      name             = app.function_app_name
      hostname         = app.function_app_default_hostname
      principal_id     = app.principal_id
    }
  }
  sensitive = false
}

output "functions" {
  description = "Created Azure Functions (Timer-triggered)"
  value = {
    for name, func in module.functions :
    name => {
      name        = func.function_name
      app_name    = func.function_app_name
    }
  }
  sensitive = false
}

output "aks_clusters" {
  description = "Created AKS Clusters"
  value = {
    for name, cluster in module.aks_clusters :
    name => {
      id                    = cluster.aks_cluster_id
      name                  = cluster.aks_cluster_name
      kube_config           = cluster.kube_config
      fqdn                  = cluster.fqdn
    }
  }
  sensitive = true
}

output "container_registries" {
  description = "Created Azure Container Registries"
  value = {
    for name, registry in module.container_registries :
    name => {
      id           = registry.registry_id
      name         = registry.registry_name
      login_server = registry.login_server
      principal_id = registry.identity_principal_id
    }
  }
  sensitive = false
}

output "mysql_servers" {
  description = "Created MySQL Servers"
  value = {
    for name, server in module.mysql_servers :
    name => {
      id                = server.mysql_server_id
      name              = server.mysql_server_name
      fqdn              = server.mysql_fqdn
    }
  }
  sensitive = false
}

output "key_vaults" {
  description = "Created Key Vaults"
  value = {
    for name, kv in module.key_vaults :
    name => {
      id     = kv.key_vault_id
      name   = kv.key_vault_name
      vault_uri = kv.vault_uri
    }
  }
  sensitive = false
}

output "redis_caches" {
  description = "Created Redis Caches"
  value = {
    for name, redis in module.redis_caches :
    name => {
      id              = redis.redis_cache_id
      name            = redis.redis_cache_name
      hostname        = redis.hostname
      port            = redis.port
      ssl_port        = redis.ssl_port
    }
  }
  sensitive = false
}

output "application_gateways" {
  description = "Created Application Gateways"
  value = {
    for name, appgw in module.application_gateway :
    name => {
      id                = appgw.appgw_id
      name              = appgw.appgw_name
      public_ip_id      = appgw.public_ip_id
      public_ip_address = appgw.public_ip_address
      public_ip_fqdn    = appgw.public_ip_fqdn
    }
  }
  sensitive = false
}

output "front_doors" {
  description = "Created Front Door Profiles"
  value = {
    for name, fd in module.front_door :
    name => {
      id                = fd.front_door_id
      name              = fd.front_door_name
      endpoint          = fd.front_door_endpoint
      custom_domains    = fd.custom_domains
    }
  }
  sensitive = false
}

# ============================================================================
# Advanced Networking Outputs
# ============================================================================

output "vnet_peerings" {
  description = "Created VNet Peerings"
  value       = module.advanced_networking.vnet_peering_ids
  sensitive   = false
}

output "route_tables" {
  description = "Created Route Tables"
  value       = module.advanced_networking.route_table_ids
  sensitive   = false
}

output "nat_gateways" {
  description = "Created NAT Gateways"
  value = {
    ids       = module.advanced_networking.nat_gateway_ids
    public_ips = module.advanced_networking.public_ip_addresses
  }
  sensitive = false
}

output "bastion_hosts" {
  description = "Created Azure Bastion Hosts"
  value       = module.advanced_networking.bastion_ids
  sensitive   = false
}

output "private_dns_zones" {
  description = "Created Private DNS Zones"
  value       = module.advanced_networking.private_dns_zone_ids
  sensitive   = false
}

output "public_ips" {
  description = "Public IP Addresses"
  value = {
    ids        = module.advanced_networking.public_ip_ids
    addresses  = module.advanced_networking.public_ip_addresses
  }
  sensitive = false
}

output "monitoring_workspace" {
  description = "Log Analytics Workspace Details"
  value = {
    workspace_id = module.monitoring.workspace_id
    workspace_name = module.monitoring.workspace_name
    workspace_resource_id = module.monitoring.workspace_resource_id
  }
  sensitive = false
}

output "backup_vault" {
  description = "Recovery Services Vault Details"
  value = {
    vault_id = module.backup.vault_id
    vault_name = module.backup.vault_name
  }
  sensitive = false
}

output "deployment_summary" {
  description = "Summary of deployed resources"
  value = {
    environment          = var.environment
    region              = var.region
    project_name        = var.project_name
    resource_count      = {
      resource_groups      = length(module.resource_groups)
      vnets               = length(module.networking)
      application_gateways = length(module.application_gateway)
      front_doors         = length(module.front_door)
      storage_accounts    = length(module.storage)
      databases           = length(module.mysql_servers) + length(module.cosmosdb_accounts) + length(module.redis_caches)
      aks_clusters        = length(module.aks_clusters)
      key_vaults          = length(module.key_vaults)
    }
    deployment_timestamp = timestamp()
  }
  sensitive = false
}
