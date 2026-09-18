# Azure Container Registry Module - main.tf

# Create Azure Container Registry
resource "azurerm_container_registry" "main" {
  count = var.registry_name != null ? 1 : 0

  name                = var.registry_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.sku

  admin_enabled                 = var.admin_enabled
  public_network_access_enabled = var.public_network_access_enabled
  zone_redundancy_enabled       = var.zone_redundancy_enabled
  export_policy_enabled         = var.export_policy_enabled
  data_endpoint_enabled         = var.data_endpoint_enabled
  network_rule_bypass_option    = var.network_rule_bypass_option
  anonymous_pull_enabled        = var.anonymous_pull_enabled

  identity {
    type         = var.identity_type
    identity_ids = var.identity_ids
  }

  quarantine_policy_enabled = var.quarantine_policy_enabled

  encryption {
    key_vault_key_id = var.encryption_key_vault_key_id
  }

  retention_policy_in_days = var.retention_policy_days

  trust_policy_enabled = var.trust_policy_enabled

  tags = merge(
    var.tags,
    {
      Environment = var.environment
      Name        = var.registry_name
    }
  )
}

# Create ACR Webhooks (optional)
resource "azurerm_container_registry_webhook" "main" {
  for_each = var.webhooks

  name                = each.value.name
  registry_name       = azurerm_container_registry.main[0].name
  resource_group_name = var.resource_group_name
  location            = var.location
  service_uri         = each.value.service_uri
  custom_headers      = each.value.custom_headers
  status              = each.value.status
  scope               = each.value.scope
  actions             = each.value.actions

  tags = var.tags
}

# Create ACR Task (optional - for automated builds)
resource "azurerm_container_registry_task" "main" {
  for_each = var.tasks

  name                  = each.value.name
  container_registry_id = azurerm_container_registry.main[0].id
  enabled               = each.value.enabled
  is_system_task        = each.value.is_system_task

  docker_step {
    image_names          = each.value.image_names
    dockerfile_path      = each.value.dockerfile_path
    context_access_token = each.value.context_access_token
    context_path         = each.value.context_path
    push_enabled         = each.value.push_enabled
    cache_enabled        = each.value.cache_enabled
  }

  platform {
    os           = each.value.platform_os
    architecture = each.value.platform_architecture
  }

  timer_trigger {
    name     = each.value.name
    enabled  = each.value.timer_trigger_enabled
    schedule = each.value.timer_trigger_schedule
  }

  tags = var.tags
}

# Role Assignment for AKS to pull images from ACR
resource "azurerm_role_assignment" "aks_acr_pull" {
  count = var.aks_principal_id != null ? 1 : 0

  name                 = var.role_assignment_name
  scope                = azurerm_container_registry.main[0].id
  role_definition_name = "AcrPull"
  principal_id         = var.aks_principal_id
}
