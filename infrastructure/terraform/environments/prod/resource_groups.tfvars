# Production Resource Groups
# Usage: terraform plan -var-file="environments/prod/_globals.tfvars" -var-file="environments/prod/resource_groups.tfvars"

resource_groups = {
  network = {
    name    = "rg-network-rewn-prod-cin"
    purpose = "Networking Infrastructure"
  }
  aks = {
    name    = "rg-aks-rewn-prod-cin"
    purpose = "Kubernetes Clusters"
  }
  databases = {
    name    = "rg-db-rewn-prod-cin"
    purpose = "Database Services"
  }
  storage = {
    name    = "rg-storage-rewn-prod-cin"
    purpose = "Storage Accounts"
  }
  security = {
    name    = "rg-security-rewn-prod-cin"
    purpose = "Security & Backup"
  }
  monitoring = {
    name    = "rg-monitor-rewn-prod-cin"
    purpose = "Monitoring & Logging"
  }
  compute = {
    name    = "rg-compute-rewn-prod-cin"
    purpose = "Compute Resources"
  }
}
