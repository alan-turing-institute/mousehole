# Create DNS zone
resource "azurerm_dns_zone" "this" {
  name                = var.domain
  resource_group_name = azurerm_resource_group.this.name
}

# Create A record for Guacamole
resource "azurerm_dns_a_record" "login" {
  name                = "login"
  zone_name           = azurerm_dns_zone.this.name
  resource_group_name = azurerm_resource_group.this.name
  ttl                 = 300
  target_resource_id  = azurerm_public_ip.guacamole.id
}

# Get DNS nameservers
data "azurerm_dns_zone" "this" {
  name                = azurerm_dns_zone.this.name
  resource_group_name = azurerm_dns_zone.this.resource_group_name
}

# Print DNS nameservers to STDOUT so that NS records can be created
output "nameservers" {
  value       = azurerm_dns_zone.this.name_servers
  description = "Ensure that your authorative DNS points your domain to these nameservers"
}
