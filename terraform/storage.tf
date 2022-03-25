locals {
  shares = {
    ingress = {
      name    = "ingress"
      size_gb = var.ingress_share_size_gb
    }
    egress = {
      name    = "egress"
      size_gb = var.egress_share_size_gb
    }
  }
}

data "external" "own_ip" {
  program = ["bash", "-c", "curl -s 'https://ipinfo.io/json'"]
}

resource "random_string" "storage_suffix" {
  length  = 24
  special = false
}

# Create storage account
resource "azurerm_storage_account" "this" {
  # Storage account names must
  #  - be all lower case
  #  - be between 3 and 24 characters
  #  - only contain numbers and letters
  #  - be globally unique
  name                = substr(lower("${local.resource_tag.storage_account}${random_string.storage_suffix.result}"), 0, 24)
  resource_group_name = azurerm_resource_group.this.name
  location            = var.location
  min_tls_version     = "TLS1_2"

  # Only FileStorage accounts support SMB/NFS shares on Premium (SSD) storage
  account_kind             = "FileStorage"
  account_tier             = "Premium"
  account_replication_type = "LRS"
  access_tier              = "Hot"

  network_rules {
    default_action             = "Deny"
    ip_rules = [data.external.own_ip.result.ip]
    virtual_network_subnet_ids = [azurerm_subnet.this.id]
  }
}

# Create ingress and egress shares
resource "azurerm_storage_share" "this" {
  for_each = local.shares

  name                 = each.value.name
  storage_account_name = azurerm_storage_account.this.name
  quota                = each.value.size_gb
}
