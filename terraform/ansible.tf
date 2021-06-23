# Register public IP address to write to Ansible inventory
# (Azure does not assign public IPs until the IP object is attached to a
# resource, hence the dependency on the virtual machine)
data "azurerm_public_ip" "dsvm" {
  name                = azurerm_public_ip.dsvm.name
  resource_group_name = azurerm_resource_group.this.name
  depends_on          = [azurerm_linux_virtual_machine.dsvm]
}

# Register public IP address to write to Ansible inventory
# (Azure does not assign public IPs until the IP object is attached to a
# resource, hence the dependency on the virtual machine)
data "azurerm_public_ip" "guacamole" {
  name                = azurerm_public_ip.guacamole.name
  resource_group_name = azurerm_resource_group.this.name
  depends_on          = [azurerm_linux_virtual_machine.guacamole]
}

# Write Ansible inventory
resource "local_file" "ansible_inventory" {
  filename        = "../ansible/inventory.yaml"
  file_permission = "0644"
  content         = <<-DOC
    ---

    all:
      hosts:
        guacamole:
          ansible_host: ${data.azurerm_public_ip.guacamole.ip_address}
          ansible_user: ${var.admin_username.guacamole}
          ansible_ssh_private_key_file: ${local_file.guacamole_admin_private_key.filename}
        dsvm:
          ansible_host: ${data.azurerm_public_ip.dsvm.ip_address}
          ansible_user: ${var.admin_username.dsvm}
          ansible_ssh_private_key_file: ${local_file.dsvm_admin_private_key.filename}
    DOC
}

# Write variables for Ansible to access
resource "local_file" "terraform_vars" {
  filename        = "../ansible/vars/terraform_vars.yaml"
  file_permission = "0644"
  content         = <<-DOC
    ---

    domain: ${var.domain}
    guacamole_domain: ${azurerm_dns_a_record.login.fqdn}
    guacamole_admin_user: ${var.admin_username.guacamole}
    guacamole_private_ip: ${azurerm_network_interface.guacamole.private_ip_address}
    dsvm_admin_user: ${var.admin_username.dsvm}
    dsvm_private_ip: ${azurerm_network_interface.dsvm.private_ip_address}
    ingress_unc: ${replace(azurerm_storage_share.this["ingress"].url, "https://", "//")}
    egress_unc: ${replace(azurerm_storage_share.this["egress"].url, "https://", "//")}
    share_username: ${azurerm_storage_account.this.name}
    share_password: ${azurerm_storage_account.this.primary_access_key}
    DOC
}
