# Create virtual machine
resource "azurerm_linux_virtual_machine" "this" {
  name                  = "${var.resource_tag.virtual_machine}_${var.name}"
  location              = var.location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.this.id]
  size                  = var.vm_size
  computer_name         = var.name
  admin_username        = var.admin_username

  disable_password_authentication = true

  admin_ssh_key {
    username   = var.admin_username
    public_key = tls_private_key.this.public_key_openssh
  }

  os_disk {
    name                 = "${var.resource_tag.os_disk}_${var.name}"
    caching              = "ReadWrite"
    storage_account_type = var.storage_type
  }

  source_image_reference {
    publisher = var.vm_image.publisher
    offer     = var.vm_image.offer
    sku       = var.vm_image.sku
    version   = var.vm_image.version
  }
}

# Create Guacamole admin key pair
resource "tls_private_key" "this" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

# Write admin account private key to a file
resource "local_file" "admin_private_key" {
  filename = "../keys/${var.name}_admin_id_rsa.pem"
  file_permission = "0600"
  content = tls_private_key.this.private_key_pem
}

# Create network interface
resource "azurerm_network_interface" "this" {
  name                = "${var.resource_tag.network_interface}_${var.name}"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.private_ip_address
    public_ip_address_id          = azurerm_public_ip.this.id
  }
}

# Create public IP
resource "azurerm_public_ip" "this" {
  name                = "${var.resource_tag.public_ip}_${var.name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"
  allocation_method   = "Static"
}

# Register public IP address (Azure does not assign public IPs until the IP
# object is attached to a resource, hence the dependency on the virtual
# machine)
data "azurerm_public_ip" "this" {
  name = azurerm_public_ip.this.name
  resource_group_name = var.resource_group_name
  depends_on          = [azurerm_linux_virtual_machine.this]
}

# Create Network Security Group
resource "azurerm_network_security_group" "this" {
  name                = "${var.resource_tag.network_security_group}_${var.name}"
  location            = var.location
  resource_group_name = var.resource_group_name
}

# Create NSG rules
resource "azurerm_network_security_rule" "this" {
  for_each                    = var.nsg_rules
  name                        = each.value.name
  priority                    = each.value.priority
  direction                   = each.value.direction
  access                      = each.value.access
  protocol                    = each.value.protocol
  source_port_range           = each.value.source_port_range
  destination_port_range      = each.value.destination_port_range
  source_address_prefix       = each.value.source_address_prefix
  destination_address_prefix  = each.value.destination_address_prefix
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.this.name
}

# Associate subnet with network security group
resource "azurerm_network_interface_security_group_association" "this" {
  network_interface_id      = azurerm_network_interface.this.id
  network_security_group_id = azurerm_network_security_group.this.id
}
