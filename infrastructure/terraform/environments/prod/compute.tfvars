# Production Compute Configuration
# AKS Clusters
# Usage: terraform plan -var-file="environments/prod/_globals.tfvars" -var-file="environments/prod/compute.tfvars"

# ============================================================================
# AKS CLUSTERS - Production (Count: 1 AKS cluster)
# ============================================================================
aks_clusters = {
  primary = {
    name                      = "aks-rewn-prod"
    kubernetes_version        = "1.28"
    default_node_pool_name    = "systempool"
    default_node_pool_count   = 3
    default_node_pool_vm_size = "Standard_D2s_v3"
    network_plugin            = "overlay"
    network_policy            = "calico"
    load_balancer_sku         = "standard"
    zones                     = ["1", "2", "3"]
    node_pools = {
      userpool = {
        name = "userpool-rewn-prod"
      }
      gpupool = {
        name = "gpupool-rewn-prod"
      }
    }
  }
}

# ============================================================================
# AZURE CONTAINER REGISTRY - Production (Count: 1 ACR)
# ============================================================================
container_registries = {
  primary = {
    name                          = "acrreewnprod"
    sku                           = "Premium"
    admin_enabled                 = false
    public_network_access_enabled = false
    zone_redundancy_enabled       = true
    export_policy_enabled         = true
    data_endpoint_enabled         = false
    network_rule_bypass_option    = "AzureServices"
    anonymous_pull_enabled        = false
    encryption_enabled            = false
    identity_type                 = "SystemAssigned"
    quarantine_policy_enabled     = false
    retention_policy_days         = 30
    trust_policy_enabled          = true
  }
}

virtual_machines = {
  mongo_rep1 = {
    name     = "vm-mongo-rep1-prod"
    nic_name = "nic-mongo-rep1-prod"
    data_disks = {
      mongo_data = {
        name = "disk-mongo-data-rep1-prod"
        size = 256
        lun  = 0
      }
    }
  }
  mongo_rep2 = {
    name     = "vm-mongo-rep2-prod"
    nic_name = "nic-mongo-rep2-prod"
    data_disks = {
      mongo_data = {
        name = "disk-mongo-data-rep2-prod"
        size = 256
        lun  = 0
      }
    }
  }
  mongo_rep3 = {
    name     = "vm-mongo-rep3-prod"
    nic_name = "nic-mongo-rep3-prod"
    data_disks = {
      mongo_data = {
        name = "disk-mongo-data-rep3-prod"
        size = 256
        lun  = 0
      }
    }
  }
  es_01 = {
    name     = "vm-es-01-prod"
    nic_name = "nic-es-01-prod"
    data_disks = {
      elasticsearch_data = {
        name = "disk-elasticsearch-data-01-prod"
        size = 512
        lun  = 0
      }
    }
  }
  es_02 = {
    name     = "vm-es-02-prod"
    nic_name = "nic-es-02-prod"
    data_disks = {
      elasticsearch_data = {
        name = "disk-elasticsearch-data-02-prod"
        size = 512
        lun  = 0
      }
    }
  }
  es_03 = {
    name     = "vm-es-03-prod"
    nic_name = "nic-es-03-prod"
    data_disks = {
      elasticsearch_data = {
        name = "disk-elasticsearch-data-03-prod"
        size = 512
        lun  = 0
      }
    }
  }
  es_04 = {
    name     = "vm-es-04-prod"
    nic_name = "nic-es-04-prod"
    data_disks = {
      elasticsearch_data = {
        name = "disk-elasticsearch-data-04-prod"
        size = 512
        lun  = 0
      }
    }
  }
  es_05 = {
    name     = "vm-es-05-prod"
    nic_name = "nic-es-05-prod"
    data_disks = {
      elasticsearch_data = {
        name = "disk-elasticsearch-data-05-prod"
        size = 512
        lun  = 0
      }
    }
  }
  openllm = {
    name     = "vm-openllm-prod"
    nic_name = "nic-openllm-prod"
  }
  nginx_proxy = {
    name     = "vm-nginx-proxy-prod"
    nic_name = "nic-nginx-proxy-prod"
  }
  nginx_web = {
    name     = "vm-nginx-web-prod"
    nic_name = "nic-nginx-web-prod"
  }
  web4 = {
    name     = "vm-web4-prod"
    nic_name = "nic-web4-prod"
  }
  web5 = {
    name     = "vm-web5-prod"
    nic_name = "nic-web5-prod"
  }
  mail1 = {
    name     = "vm-mail1-prod"
    nic_name = "nic-mail1-prod"
  }
  chroma = {
    name     = "vm-chroma-prod"
    nic_name = "nic-chroma-prod"
  }
}
