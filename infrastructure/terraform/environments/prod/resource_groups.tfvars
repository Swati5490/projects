resource_groups = {

  rg_network = {
    name    = "rg-network-rewn-prod"
    purpose = "Networking Infrastructure"
    create  = true
  }

  rg_databases = {
    name    = "rg-db-rewn-prod"
    purpose = "Database Services"
    create  = true
  }

  rg_app = {
    name    = "rg-app-rewn-prod"
    purpose = "Application Services"
    create  = true
  }

  rg_storage = {
    name    = "rg-storage-rewn-prod"
    purpose = "Storage Accounts"
    create  = true
  }

  rg_security = {
    name    = "rg-security-rewn-prod"
    purpose = "Security & Backup"
    create  = true
  }

  rg_monitoring = {
    name    = "rg-monitor-rewn-prod"
    purpose = "Monitoring & Logging"
    create  = true
  }

  rg_compute = {
    name    = "rg-compute-rewn-prod"
    purpose = "Compute Resources"
    create  = true
  }
}