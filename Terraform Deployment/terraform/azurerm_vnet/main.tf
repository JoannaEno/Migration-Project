


resource "azurerm_virtual_network" "virtual_network" {
  name = var.virtual_network_name
  resource_group_name = var.resource_group_name
  location = var.location
  address_space = [ var.address_space ]

  # dynamic "subnet" {
  #   for_each = var.subnet
  #   content {
  #     name = subnet.value.name == "" ? null : subnet.value.name
  #     address_prefix = subnet.value.address_prefix == "" ? null : subnet.value.address_prefix
  #     security_group = subnet.value.security_group == "" ? null : subnet.value.security_group
  #   }
  # }
}