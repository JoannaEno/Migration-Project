data "azurerm_private_dns_zone" "private_dns_zone" {
  name = var.private_dns_name
}

data "azurerm_subnet" "pe_subnet" {
  name = var.private_endpoint_subnet_name
  virtual_network_name = var.virtual_network_name
  resource_group_name = var.resource_group_name
}


resource "azurerm_private_endpoint" "private_endpoint" {
  name                = "${var.private_endpoint_name}-endpoint"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = data.azurerm_subnet.pe_subnet.id
  

  private_service_connection {
    name                           = "${var.private_endpoint_name}-privateconnection"
    private_connection_resource_id = var.private_connection_resource_id #basically resource ID
    subresource_names = [var.sub_resource_name]
    is_manual_connection = false
  }

  private_dns_zone_group {
    name = "${var.resource_name}-dzg"
    private_dns_zone_ids = [data.azurerm_private_dns_zone.private_dns_zone.id]
  }
}
