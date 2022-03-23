# Write Ansible inventory
resource "local_file" "ansible_inventory" {
  filename        = "../ansible/inventory.yaml"
  file_permission = "0644"
  content         = <<-DOC
    ---

    all:
      hosts:
        guacamole:
          ansible_host: ${module.virtual_machines["guacamole"].public_ip_address.ip_address}
          ansible_user: ${local.virtual_machines.guacamole.admin_username}
          ansible_ssh_private_key_file: ${module.virtual_machines["guacamole"].admin_private_key_file.filename}
        dsvm:
          ansible_host: ${module.virtual_machines["dsvm"].public_ip_address.ip_address}
          ansible_user: ${local.virtual_machines.dsvm.admin_username}
          ansible_ssh_private_key_file: ${module.virtual_machines["dsvm"].admin_private_key_file.filename}
        ldap:
          ansible_host: ${module.virtual_machines["ldap"].public_ip_address.ip_address}
          ansible_user: ${local.virtual_machines.ldap.admin_username}
          ansible_ssh_private_key_file: ${module.virtual_machines["ldap"].admin_private_key_file.filename}
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
    guacamole_admin_user: ${local.virtual_machines.guacamole.admin_username}
    guacamole_private_ip: ${local.virtual_machines.guacamole.private_ip_address}
    dsvm_admin_user: ${local.virtual_machines.dsvm.admin_username}
    dsvm_private_ip: ${local.virtual_machines.dsvm.private_ip_address}
    ingress_unc: ${replace(azurerm_storage_share.this["ingress"].url, "https://", "//")}
    egress_unc: ${replace(azurerm_storage_share.this["egress"].url, "https://", "//")}
    share_username: ${azurerm_storage_account.this.name}
    share_password: ${azurerm_storage_account.this.primary_access_key}
    DOC
}
