# Create resource group
resource "azurerm_resource_group" "this" {
  name     = local.resource_tag.resource_group
  location = var.location
}
