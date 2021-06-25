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
  virtual_machine_id = module.virtual_machines["dsvm"].virtual_machine.id
  lun                = "0"
  caching            = "ReadWrite"
}
