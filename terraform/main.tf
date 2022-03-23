locals {
  virtual_machines = {
    guacamole = {
      name               = "guacamole"
      vm_size            = var.vm_size.guacamole
      admin_username     = "guacamole_admin"
      private_ip_address = "10.1.0.4"

      nsg_rules = {
        ssh   = local.network_security_group_rules.ssh
        http  = local.network_security_group_rules.http
        https = local.network_security_group_rules.https
      }
    }
    dsvm = {
      name               = "dsvm"
      vm_size            = var.vm_size.dsvm
      admin_username     = "dsvm_admin"
      private_ip_address = "10.1.0.5"

      nsg_rules = {
        ssh = local.network_security_group_rules.ssh
        rdp = local.network_security_group_rules.rdp
      }
    }
    ldap = {
      name               = "ldap"
      vm_size            = var.vm_size.ldap
      admin_username     = "ldap_admin"
      private_ip_address = "10.1.0.6"

      nsg_rules = {
        ssh = local.network_security_group_rules.ssh
      }
    }
  }
}

module "virtual_machines" {
  source   = "./modules/virtual_machines/"
  for_each = local.virtual_machines

  resource_tag        = local.resource_tag
  location            = var.location
  storage_type        = var.storage_type
  vm_image            = var.vm_image
  resource_group_name = azurerm_resource_group.this.name
  subnet_id           = azurerm_subnet.this.id

  name               = each.value.name
  vm_size            = each.value.vm_size
  admin_username     = each.value.admin_username
  private_ip_address = each.value.private_ip_address
  nsg_rules          = each.value.nsg_rules
}
