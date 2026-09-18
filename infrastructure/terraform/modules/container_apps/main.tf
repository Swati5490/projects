resource "azurerm_container_app" "main" {
  name                         = var.name
  container_app_environment_id = var.container_app_environment_id
  resource_group_name          = var.resource_group_name
  revision_mode                = var.revision_mode

  dynamic "identity" {
    for_each = var.managed_identity_id != null ? [1] : []

    content {
      type         = "UserAssigned"
      identity_ids = [var.managed_identity_id]
    }
  }

  template {
    min_replicas = var.min_replicas
    max_replicas = var.max_replicas

    container {
      name   = var.container_name
      image  = var.image
      cpu    = var.cpu
      memory = var.memory

      dynamic "env" {
        for_each = var.environment_variables

        content {
          name  = env.key
          value = env.value
        }
      }
    }

    dynamic "http_scale_rule" {
      for_each = var.http_scale_rule != null ? [var.http_scale_rule] : []

      content {
        name                = http_scale_rule.value.name
        concurrent_requests = http_scale_rule.value.concurrent_requests
      }
    }
  }

  dynamic "ingress" {
    for_each = var.ingress != null ? [var.ingress] : []

    content {
      external_enabled           = ingress.value.external_enabled
      target_port                = ingress.value.target_port
      transport                  = ingress.value.transport
      allow_insecure_connections = ingress.value.allow_insecure_connections

      traffic_weight {
        percentage      = 100
        latest_revision = true
      }
    }
  }

  tags = merge(
    var.tags,
    {
      Environment = var.environment
      Project     = var.project_name
    }
  )
}