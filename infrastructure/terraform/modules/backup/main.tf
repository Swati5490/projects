# Backup Module - main.tf

# Recovery Services Vault
resource "azurerm_recovery_services_vault" "main" {
  name                = "rsv-${var.project_name}-${var.environment}"
  location            = var.region
  resource_group_name = var.resource_groups["security"].name
  sku                 = "Standard"

  tags = merge(
    var.tags,
    {
      Environment = var.environment
    }
  )
}

# Backup Policy
resource "azurerm_backup_policy_vm" "main" {
  name                = "bp-${var.project_name}-${var.environment}"
  resource_group_name = var.resource_groups["security"].name
  recovery_vault_name = azurerm_recovery_services_vault.main.name

  backup {
    frequency = "Daily"
    time      = "02:00"
  }

  retention_daily {
    count = 30
  }

  retention_weekly {
    count    = 12
    weekdays = ["Sunday"]
  }

  retention_monthly {
    count    = 12
    weekdays = ["Sunday"]
    weeks    = ["First"]
  }

  retention_yearly {
    count    = 7
    months   = ["December"]
    weekdays = ["Sunday"]
    weeks    = ["First"]
  }
}
