#Data Source for Virtual Network
data "azurerm_virtual_network" "name" {
  name = var.virtual_network_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone" "private_dns_zone" {
  name                = var.private_dns_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "virtual_network_link" {
  name                  = "${var.private_dns_name}-vntlink"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.private_dns_zone.name
  virtual_network_id    = data.azurerm_virtual_network.name.id
}

