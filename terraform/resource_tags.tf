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
    data_disk              = "DATADISK_${var.sre_name}"
    storage_account        = "STORAGE${var.sre_name}"
    storage_share          = "SHARE_${var.sre_name}"
  }
}
