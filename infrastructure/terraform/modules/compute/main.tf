# Compute Module - main.tf

resource "azurerm_kubernetes_cluster" "main" {
  name                = var.cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = "${var.cluster_name}-dns"
  kubernetes_version  = var.kubernetes_version

  default_node_pool {
    name       = var.default_node_pool_name
    node_count = var.default_node_pool_count
    vm_size    = var.default_node_pool_vm_size
    zones      = var.zones
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin      = var.network_plugin
    network_policy      = var.network_policy
    network_plugin_mode = var.network_plugin_mode
    load_balancer_sku   = var.load_balancer_sku
  }

  role_based_access_control_enabled = true

  tags = merge(
    var.tags,
    {
      Environment = var.environment
    }
  )
}

resource "azurerm_kubernetes_cluster_node_pool" "main" {
  for_each = var.node_pools

  name                  = each.value.name
  kubernetes_cluster_id = azurerm_kubernetes_cluster.main.id
  vm_size               = each.value.vm_size
  node_count            = each.value.node_count
  mode                  = each.value.mode
  zones                 = length(each.value.zones) > 0 ? each.value.zones : null
}
