variable "subscription_id" {
  type = string
}

variable "location" {
  type    = string
  default = "uksouth"
}

variable "sre_name" {
  type = string
}

variable "domain" {
  type = string
}

variable "vm_size" {
  type = map(string)
  default = {
    guacamole = "Standard_D4s_v4"
    dsvm      = "Standard_D32s_v4"
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

variable "shared_disk_size_gb" {
  type = number
  validation {
    condition     = var.shared_disk_size_gb > 0
    error_message = "The shared disk size must be a positive integer."
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

variable "ingress_share_size_gb" {
  type = number
  validation {
    condition     = var.ingress_share_size_gb >= 100
    error_message = "The share size must be a positive integer >= 100."
  }
}

variable "egress_share_size_gb" {
  type = number
  validation {
    condition     = var.egress_share_size_gb >= 100
    error_message = "The share size must be a positive integer >= 100."
  }
}
