variable "location" {
  type        = string
  default     = "uksouth"
}

variable "sre_name" {
  type = string
}

variable "domain" {
  type = string
}

locals {
    resource_tag = {
      resource_group         = "RG_${var.sre_name}"
      virtual_network        = "VNET_${var.sre_name}"
      subnet                 = "SUBNET_${var.sre_name}"
      public_ip              = "PUBIP_${var.sre_name}"
      network_security_group = "NSG_${var.sre_name}"
      network_interface      = "NIC_${var.sre_name}"
      virtual_machine        = "VM_${var.sre_name}"
      os_disk                = "OSDISK_${var.sre_name}"
    }

    guacamole_nsg_rules = {
      ssh   = var.nsg_rule_ssh
      http  = var.nsg_rule_http
      https = var.nsg_rule_https
    }

    dsvm_nsg_rules = {
      ssh = var.nsg_rule_ssh
      rdp = var.nsg_rule_rdp
    }
}

variable "vm_size" {
  type    = map(string)
  default = {
    guacamole = "Standard_B2s"
    dsvm      = "Standard_D4s_v3"
  }
}

variable "admin_username" {
  type = map(string)
  default = {
    guacamole = "guacamole_admin"
    dsvm = "dsvm_admin"
  }
}

variable "storage_type" {
  type    = string
  default = "StandardSSD_LRS"
  validation {
    condition     = can(contains(["Standard_LRS", "StandardSSD_LRS", "Premium_LRS"], var.storage_type))
    error_message = "The storage type must be one of Standard_LRS, StandardSSD_LRS and Premium_LRS."
  }
}

variable "vm_image" {
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
  default = {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }
}

variable "nsg_rule_ssh" {
  type = map(string)
  default = {
    name                        = "SSH"
    priority                    = 1001
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "22"
    source_address_prefix       = "*"
    destination_address_prefix  = "*"
  }
}

variable "nsg_rule_http" {
  type = map(string)
  default = {
    name                        = "HTTP"
    priority                    = 1002
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "80"
    source_address_prefix       = "*"
    destination_address_prefix  = "*"
  }
}

variable "nsg_rule_https" {
  type = map(string)
  default = {
    name                        = "HTTPS"
    priority                    = 1003
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "443"
    source_address_prefix       = "*"
    destination_address_prefix  = "*"
  }
}

variable "nsg_rule_rdp" {
  type = map(string)
  default = {
    name                        = "RDP"
    priority                    = 1004
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "3389"
    source_address_prefix       = "VirtualNetwork"
    destination_address_prefix  = "*"
  }
}
