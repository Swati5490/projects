# ============================================================================
# RESOURCE GROUP OUTPUTS
# ============================================================================

output "resource_groups" {
  description = "Created Resource Groups"

  value = {
    for key, rg in module.resource_groups :
    key => {
      id       = rg.id
      name     = rg.name
      location = rg.location
    }
  }
}


# ============================================================================
# VNET OUTPUTS
# ============================================================================

output "vnet_ids" {
  description = "IDs of created VNets"

  value = module.networking.vnet_ids
}

output "vnet_names" {
  description = "Names of created VNets"

  value = module.networking.vnet_names
}

output "vnet_resource_group_names" {
  description = "Resource group names of created VNets"

  value = module.networking.vnet_resource_group_names
}


# ============================================================================
# SUBNET OUTPUTS
# ============================================================================

output "subnet_ids" {
  description = "IDs of created Subnets"

  value = module.networking.subnet_ids
}

output "subnet_names" {
  description = "Names of created Subnets"

  value = module.networking.subnet_names
}


# ============================================================================
# PRIVATE DNS ZONE OUTPUTS
# ============================================================================

output "private_dns_zone_ids" {
  description = "Private DNS Zone IDs"

  value = module.networking.private_dns_zone_ids
}

output "private_dns_zone_names" {
  description = "Private DNS Zone names"

  value = module.networking.private_dns_zone_names
}

# ============================================================================
# KEY VAULT OUTPUTS
# ============================================================================
/***
output "key_vault_id" {
  description = "ID of the Production Key Vault"
  value       = module.security.key_vault_id
}

output "key_vault_name" {
  description = "Name of the Production Key Vault"
  value       = module.security.key_vault_name
}

output "key_vault_uri" {
  description = "URI of the Production Key Vault"
  value       = module.security.key_vault_uri
}
***/

# ============================================================================
# MANAGED IDENTITY OUTPUTS
# ============================================================================

output "managed_identity_ids" {
  description = "IDs of Production managed identities"
  value       = module.security.managed_identity_ids
}

output "managed_identity_principal_ids" {
  description = "Principal IDs of Production managed identities"
  value       = module.security.managed_identity_principal_ids
}

output "managed_identity_client_ids" {
  description = "Client IDs of Production managed identities"
  value       = module.security.managed_identity_client_ids
}

output "managed_identity_names" {
  description = "Names of Production managed identities"
  value       = module.security.managed_identity_names
}


# ============================================================================
# FEDERATED IDENTITY CREDENTIAL OUTPUTS
# ============================================================================

output "federated_identity_credential_ids" {
  description = "IDs of Production federated identity credentials"
  value       = module.security.federated_identity_credential_ids
}


# ============================================================================
# ROLE ASSIGNMENT OUTPUTS
# ============================================================================

output "role_assignment_ids" {
  description = "IDs of Production role assignments"
  value       = module.security.role_assignment_ids
}

# ============================================================================
# COSMOS DB - MONGODB
# ============================================================================

output "cosmos_mongo_ids" {
  description = "Cosmos MongoDB account IDs"

  value = {
    for key, account in module.cosmos_mongo :
    key => account.id
  }
}

output "cosmos_mongo_names" {
  description = "Cosmos MongoDB account names"

  value = {
    for key, account in module.cosmos_mongo :
    key => account.name
  }
}

output "cosmos_mongo_endpoints" {
  description = "Cosmos MongoDB endpoints"

  value = {
    for key, account in module.cosmos_mongo :
    key => account.endpoint
  }
}

output "cosmos_mongo_database_ids" {
  description = "MongoDB database IDs"

  value = {
    for key, account in module.cosmos_mongo :
    key => account.mongo_database_ids
  }
}

output "cosmos_mongo_database_names" {
  description = "MongoDB database names"

  value = {
    for key, account in module.cosmos_mongo :
    key => account.mongo_database_names
  }
}

output "cosmos_mongo_collection_ids" {
  description = "MongoDB collection IDs"

  value = {
    for key, account in module.cosmos_mongo :
    key => account.mongo_collection_ids
  }
}

output "cosmos_mongo_collection_names" {
  description = "MongoDB collection names"

  value = {
    for key, account in module.cosmos_mongo :
    key => account.mongo_collection_names
  }
}


# ============================================================================
# COSMOS DB - NOSQL
# ============================================================================

output "cosmos_nosql_ids" {
  description = "Cosmos DB NoSQL account IDs"

  value = {
    for key, account in module.cosmos_nosql :
    key => account.id
  }
}

output "cosmos_nosql_names" {
  description = "Cosmos DB NoSQL account names"

  value = {
    for key, account in module.cosmos_nosql :
    key => account.name
  }
}

output "cosmos_nosql_endpoints" {
  description = "Cosmos DB NoSQL endpoints"

  value = {
    for key, account in module.cosmos_nosql :
    key => account.endpoint
  }
}

output "cosmos_nosql_database_ids" {
  description = "Cosmos DB NoSQL database IDs"

  value = {
    for key, account in module.cosmos_nosql :
    key => account.sql_database_ids
  }
}

output "cosmos_nosql_database_names" {
  description = "Cosmos DB NoSQL database names"

  value = {
    for key, account in module.cosmos_nosql :
    key => account.sql_database_names
  }
}

output "cosmos_nosql_container_ids" {
  description = "Cosmos DB NoSQL container IDs"

  value = {
    for key, account in module.cosmos_nosql :
    key => account.sql_container_ids
  }
}

output "cosmos_nosql_container_names" {
  description = "Cosmos DB NoSQL container names"

  value = {
    for key, account in module.cosmos_nosql :
    key => account.sql_container_names
  }
}


# ============================================================================
# PRIVATE ENDPOINTS
# ============================================================================

output "cosmos_mongo_private_endpoint_ids" {
  description = "MongoDB Cosmos private endpoint IDs"

  value = {
    for key, account in module.cosmos_mongo :
    key => account.private_endpoint_id
  }
}

output "cosmos_nosql_private_endpoint_ids" {
  description = "NoSQL Cosmos private endpoint IDs"

  value = {
    for key, account in module.cosmos_nosql :
    key => account.private_endpoint_id
  }
}

# ============================================================================
# MYSQL
# ============================================================================

output "mysql_server_ids" {
  description = "MySQL Flexible Server IDs"

  value = {
    for key, mysql in module.mysql_servers :
    key => mysql.mysql_server_id
  }
}

output "mysql_server_names" {
  description = "MySQL Flexible Server names"

  value = {
    for key, mysql in module.mysql_servers :
    key => mysql.mysql_server_name
  }
}

output "mysql_server_fqdns" {
  description = "MySQL Flexible Server FQDNs"

  value = {
    for key, mysql in module.mysql_servers :
    key => mysql.mysql_fqdn
  }
}

output "mysql_server_sku_names" {
  description = "MySQL Flexible Server SKUs"

  value = {
    for key, mysql in module.mysql_servers :
    key => mysql.mysql_sku_name
  }
}

output "mysql_server_versions" {
  description = "MySQL versions"

  value = {
    for key, mysql in module.mysql_servers :
    key => mysql.mysql_version
  }
}

output "mysql_server_zones" {
  description = "MySQL availability zones"

  value = {
    for key, mysql in module.mysql_servers :
    key => mysql.mysql_zone
  }
}


# ============================================================================
# MYSQL PRIVATE ENDPOINT
# ============================================================================

output "mysql_private_endpoint_ids" {
  description = "MySQL private endpoint IDs"

  value = {
    for key, mysql in module.mysql_servers :
    key => mysql.mysql_private_endpoint_id
  }
}

output "mysql_private_endpoint_names" {
  description = "MySQL private endpoint names"

  value = {
    for key, mysql in module.mysql_servers :
    key => mysql.mysql_private_endpoint_name
  }
}

output "mysql_private_endpoint_ips" {
  description = "MySQL private endpoint IP addresses"

  value = {
    for key, mysql in module.mysql_servers :
    key => mysql.mysql_private_endpoint_ip
  }
}
output "private_endpoint_ids" {
  value = {
    for key, pe in module.private_endpoints :
    key => pe.id
  }
}

output "private_endpoint_names" {
  value = {
    for key, pe in module.private_endpoints :
    key => pe.name
  }
}

output "private_endpoint_private_ip_addresses" {
  value = {
    for key, pe in module.private_endpoints :
    key => pe.private_ip_address
  }
}

output "container_app_ids" {
  value = {
    for key, app in module.container_apps :
    key => app.id
  }
}

output "container_app_names" {
  value = {
    for key, app in module.container_apps :
    key => app.name
  }
}

output "container_app_latest_revision_names" {
  value = {
    for key, app in module.container_apps :
    key => app.latest_revision_name
  }
}

output "container_app_latest_revision_fqdns" {
  value = {
    for key, app in module.container_apps :
    key => app.latest_revision_fqdn
  }
}

output "container_app_outbound_ip_addresses" {
  value = {
    for key, app in module.container_apps :
    key => app.outbound_ip_addresses
  }
}