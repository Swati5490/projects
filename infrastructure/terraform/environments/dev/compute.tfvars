# Development Compute Configuration
# AKS Clusters
# Usage: terraform plan -var-file="environments/dev/_globals.tfvars" -var-file="environments/dev/compute.tfvars"

# ============================================================================
# AKS CLUSTERS - Development (Count: 1 AKS cluster)
# ============================================================================
aks_clusters = {
  dev = {
    name                      = "aks-rewn-dev-cin"
    kubernetes_version        = "1.28"
    default_node_pool_name    = "systempool"
    default_node_pool_count   = 1
    default_node_pool_vm_size = "Standard_B2s"
    network_plugin            = "azure"
    load_balancer_sku         = "standard"
    zones                     = ["1"]
  }
}
