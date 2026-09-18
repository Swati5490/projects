# ============================================================================
# RESOURCE GROUP
# ============================================================================

resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.region

  tags =  var.tags
}