terraform {
  backend "azurerm" {
    resource_group_name  = "rg-global-rewn"
    storage_account_name = "sttfstaterewn"
    container_name       = "tfstate"
    key                  = "dev.tfstate"
  }
}