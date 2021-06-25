# Create virtual network
resource "azurerm_virtual_network" "this" {
  name                = local.resource_tag.virtual_network
  address_space       = ["10.1.0.0/16"]
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name
}

# Create subnet
resource "azurerm_subnet" "this" {
  name                 = local.resource_tag.subnet
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = ["10.1.0.0/16"]
}

