# Production Compute Configuration
# AKS Clusters
# Usage: terraform plan -var-file="environments/prod/_globals.tfvars" -var-file="environments/prod/compute.tfvars"

# ============================================================================
# AKS CLUSTERS - Production (Count: 1 AKS cluster)
# ============================================================================
aks_clusters = {
  primary = {
    name                      = "aks-rewn-prod-cin"
    kubernetes_version        = "1.28"
    default_node_pool_name    = "systempool"
    default_node_pool_count   = 3
    default_node_pool_vm_size = "Standard_D2s_v3"
    network_plugin            = "overlay"
    network_policy            = "calico"
    load_balancer_sku         = "standard"
    zones                     = ["1", "2", "3"]
  }
}

# ============================================================================
# AZURE CONTAINER REGISTRY - Production (Count: 1 ACR)
# ============================================================================
container_registries = {
  primary = {
    name                         = "acrreewnprod"
    sku                          = "Premium"
    admin_enabled                = false
    public_network_access_enabled = false
    zone_redundancy_enabled      = true
    export_policy_enabled        = true
    data_endpoint_enabled        = false
    network_rule_bypass_option   = "AzureServices"
    anonymous_pull_enabled       = false
    encryption_enabled           = false
    identity_type                = "SystemAssigned"
    quarantine_policy_enabled    = false
    retention_policy_days        = 30
    trust_policy_enabled         = true
  }
}
