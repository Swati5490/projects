resource_groups = {

  rg_network = {
    name    = "rg-network-rewn-dev"
    purpose = "Dev Networking"
    create  = true
  }

  rg_aks = {
    name    = "rg-aks-rewn-dev"
    purpose = "Dev AKS Cluster"
    create  = true
  }

  rg_databases = {
    name    = "rg-db-rewn-dev"
    purpose = "Dev Databases"
    create  = true
  }

  rg_storage = {
    name    = "rg-storage-rewn-dev"
    purpose = "Dev Storage"
    create  = true
  }

  rg_security = {
    name    = "rg-security-rewn-dev"
    purpose = "Dev Security"
    create  = true
  }

  rg_monitoring = {
    name    = "rg-monitor-rewn-dev"
    purpose = "Dev Monitoring"
    create  = true
  }

  rg_compute = {
    name    = "rg-compute-rewn-dev"
    purpose = "Dev Compute"
    create  = true
  }
}