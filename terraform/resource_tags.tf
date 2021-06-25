locals {
  resource_tag = {
    resource_group         = "rg_${var.sre_name}"
    virtual_network        = "vnet_${var.sre_name}"
    subnet                 = "subnet_${var.sre_name}"
    public_ip              = "pubip_${var.sre_name}"
    network_security_group = "nsg_${var.sre_name}"
    network_interface      = "nic_${var.sre_name}"
    virtual_machine        = "vm_${var.sre_name}"
    os_disk                = "osdisk_${var.sre_name}"
    data_disk              = "datadisk_${var.sre_name}"
    storage_account        = "storage${var.sre_name}"
    storage_share          = "share_${var.sre_name}"
  }
}
