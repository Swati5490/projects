# Development Compute Configuration
# AKS Clusters
# Usage: terraform plan -var-file="environments/dev/_globals.tfvars" -var-file="environments/dev/compute.tfvars"

# ============================================================================
# AKS CLUSTERS - Development (Count: 1 AKS cluster)
# ============================================================================
aks_clusters = {
  dev = {
    name                      = "aks-rewn-dev"
    kubernetes_version        = "1.28"
    default_node_pool_name    = "systempool"
    default_node_pool_count   = 1
    default_node_pool_vm_size = "Standard_B2s"
    network_plugin            = "azure"
    load_balancer_sku         = "standard"
    zones                     = ["1"]
    node_pools = {
      userpool = {
        name = "userpool-rewn-dev"
      }
    }
  }
}

virtual_machines = {
  mongo_rep1 = {
    name     = "vm-mongo-rep1-dev"
    nic_name = "nic-mongo-rep1-dev"
  }
  mongo_rep2 = {
    name     = "vm-mongo-rep2-dev"
    nic_name = "nic-mongo-rep2-dev"
  }
  mongo_rep3 = {
    name     = "vm-mongo-rep3-dev"
    nic_name = "nic-mongo-rep3-dev"
  }
  chroma = {
    name     = "vm-chroma-dev"
    nic_name = "nic-chroma-dev"
  }
}
