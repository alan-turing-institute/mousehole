output "network_interface" {
  value = azurerm_network_interface.this
}

output "virtual_machine" {
  value = azurerm_linux_virtual_machine.this
}

output "admin_private_key_file" {
  value = local_file.admin_private_key
}

output "public_ip" {
  value = azurerm_public_ip.this
}

output "public_ip_address" {
  value = data.azurerm_public_ip.this
}
