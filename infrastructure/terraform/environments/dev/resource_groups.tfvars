# Development Resource Groups
# Usage: terraform plan -var-file="environments/dev/_globals.tfvars" -var-file="environments/dev/resource_groups.tfvars"

resource_groups = {
  network = {
    name    = "rg-network-rewn-dev-cin"
    purpose = "Dev Networking"
  }
  aks = {
    name    = "rg-aks-rewn-dev-cin"
    purpose = "Dev AKS Cluster"
  }
  databases = {
    name    = "rg-db-rewn-dev-cin"
    purpose = "Dev Databases"
  }
  storage = {
    name    = "rg-storage-rewn-dev-cin"
    purpose = "Dev Storage"
  }
  security = {
    name    = "rg-security-rewn-dev-cin"
    purpose = "Dev Security"
  }
  monitoring = {
    name    = "rg-monitor-rewn-dev-cin"
    purpose = "Dev Monitoring"
  }
  compute = {
    name    = "rg-compute-rewn-dev-cin"
    purpose = "Dev Compute"
  }
}
