# Create Network Security Group
resource "azurerm_network_security_group" "guacamole" {
  name                = "${local.resource_tag.network_security_group}_guacamole"
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name
}

# Create Guacamole NSG rules
resource "azurerm_network_security_rule" "guacamole" {
  for_each                    = local.guacamole_nsg_rules
  name                        = each.value.name
  priority                    = each.value.priority
  direction                   = each.value.direction
  access                      = each.value.access
  protocol                    = each.value.protocol
  source_port_range           = each.value.source_port_range
  destination_port_range      = each.value.destination_port_range
  source_address_prefix       = each.value.source_address_prefix
  destination_address_prefix  = each.value.destination_address_prefix
  resource_group_name         = azurerm_resource_group.this.name
  network_security_group_name = azurerm_network_security_group.guacamole.name
}

# Associate subnet with network security group
resource "azurerm_network_interface_security_group_association" "guacamole" {
  network_interface_id      = azurerm_network_interface.guacamole.id
  network_security_group_id = azurerm_network_security_group.guacamole.id
}

# Create public IP
resource "azurerm_public_ip" "guacamole" {
  name                = "${local.resource_tag.public_ip}_guacamole"
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name
  sku                 = "Standard"
  allocation_method   = "Static"
}

# Create network interface
resource "azurerm_network_interface" "guacamole" {
  name                = "${local.resource_tag.network_interface}_guacamole"
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name

  ip_configuration {
    name                          = "guacamole"
    subnet_id                     = azurerm_subnet.this.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.1.0.4"
    public_ip_address_id          = azurerm_public_ip.guacamole.id
  }
}

# Create Guacamole admin key pair
resource "tls_private_key" "guacamole_admin" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

# Write admin account private key to a file
resource "local_file" "guacamole_admin_private_key" {
  filename        = "../keys/guacamole_admin_id_rsa.pem"
  file_permission = "0600"
  content         = tls_private_key.guacamole_admin.private_key_pem
}

# Create Guacamole virtual machine
resource "azurerm_linux_virtual_machine" "guacamole" {
  name                  = "${local.resource_tag.virtual_machine}_guacamole"
  location              = var.location
  resource_group_name   = azurerm_resource_group.this.name
  network_interface_ids = [azurerm_network_interface.guacamole.id]
  size                  = var.vm_size.guacamole
  computer_name         = "guacamole"
  admin_username        = var.admin_username.guacamole

  disable_password_authentication = true

  admin_ssh_key {
    username   = var.admin_username.guacamole
    public_key = tls_private_key.guacamole_admin.public_key_openssh
  }

  os_disk {
    name                 = "${local.resource_tag.os_disk}_guacamole"
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

# Create Network Security Group
resource "azurerm_network_security_group" "dsvm" {
  name                = "${local.resource_tag.network_security_group}_dsvm"
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name
}

# Create Guacamole NSG rules
resource "azurerm_network_security_rule" "dsvm" {
  for_each                    = local.dsvm_nsg_rules
  name                        = each.value.name
  priority                    = each.value.priority
  direction                   = each.value.direction
  access                      = each.value.access
  protocol                    = each.value.protocol
  source_port_range           = each.value.source_port_range
  destination_port_range      = each.value.destination_port_range
  source_address_prefix       = each.value.source_address_prefix
  destination_address_prefix  = each.value.destination_address_prefix
  resource_group_name         = azurerm_resource_group.this.name
  network_security_group_name = azurerm_network_security_group.dsvm.name
}

# Associate subnet with network security group
resource "azurerm_network_interface_security_group_association" "dsvm" {
  network_interface_id      = azurerm_network_interface.dsvm.id
  network_security_group_id = azurerm_network_security_group.dsvm.id
}

# Create public IP
resource "azurerm_public_ip" "dsvm" {
  name                = "${local.resource_tag.public_ip}_dsvm"
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name
  sku                 = "Standard"
  allocation_method   = "Static"
}

# Create network interface
resource "azurerm_network_interface" "dsvm" {
  name                = "${local.resource_tag.network_interface}_dsvm"
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name

  ip_configuration {
    name                          = "dsvm"
    subnet_id                     = azurerm_subnet.this.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.1.0.5"
    public_ip_address_id          = azurerm_public_ip.dsvm.id
  }
}

# Create DSVM admin key pair
resource "tls_private_key" "dsvm_admin" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

# Write admin account private key to a file
resource "local_file" "dsvm_admin_private_key" {
  filename        = "../keys/dsvm_admin_id_rsa.pem"
  file_permission = "0600"
  content         = tls_private_key.dsvm_admin.private_key_pem
}

# Create DSVM virtual machine
resource "azurerm_linux_virtual_machine" "dsvm" {
  name                  = "${local.resource_tag.virtual_machine}_dsvm"
  location              = var.location
  resource_group_name   = azurerm_resource_group.this.name
  network_interface_ids = [azurerm_network_interface.dsvm.id]
  size                  = var.vm_size.dsvm
  computer_name         = "dsvm"
  admin_username        = var.admin_username.dsvm

  disable_password_authentication = true

  admin_ssh_key {
    username   = var.admin_username.dsvm
    public_key = tls_private_key.dsvm_admin.public_key_openssh
  }

  os_disk {
    name                 = "${local.resource_tag.os_disk}_dsvm"
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

# Create shared data disk
resource "azurerm_managed_disk" "this" {
  name                = "${local.resource_tag.data_disk}_shared"
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name

  storage_account_type = var.storage_type
  create_option        = "Empty"
  disk_size_gb         = var.shared_disk_size_gb
}

# Attach shared data disk to DSVM
resource "azurerm_virtual_machine_data_disk_attachment" "this" {
  managed_disk_id    = azurerm_managed_disk.this.id
  virtual_machine_id = azurerm_linux_virtual_machine.dsvm.id
  lun                = "0"
  caching            = "ReadWrite"
}
