

# data "azurerm_subnet" "vmss_subnet" {
#   name = var.vmss_subnet_name
#   virtual_network_name = var.virtual_network_name
#   resource_group_name = var.resource_group_name
# }

# resource "azurerm_user_assigned_identity" "user_assigned_identity" {
#   resource_group_name = var.resource_group_name
#   name = "vmss-cmp-ukspoc-identity"
#   location = var.location
# }

resource "azurerm_windows_virtual_machine_scale_set" "example" {
  name                = var.vmss_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.vmss_sku
  instances           = 1
  admin_username      = "adminuser"
  admin_password = "joannaeno123$"
  computer_name_prefix = "vmss-cmp"

  # identity {
  #   type = "UserAssigned"
  #   identity_ids = [ azurerm_user_assigned_identity.user_assigned_identity.id ]
  # }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter-Server-Core"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name    = "${var.vmss_name}-interface"
    primary = true

    ip_configuration {
      name      = "${var.vmss_name}-iponfig"
      primary   = true
      subnet_id = var.subnet_id
    }
  }
}


#RSV CREATION
#Managed Identity Creation
# resource "azurerm_user_assigned_identity" "vm_server_mi" {
#   resource_group_name = var.resource_group_name
#   location            = var.location
#   name                = "${var.rsv_name}identity"
# }

resource "azurerm_recovery_services_vault" "vault" {
  name                = var.rsv_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"
  # identity {
  #   type = "UserAssigned"
  #   identity_ids = [ azurerm_user_assigned_identity.vm_server_mi.id ]
  # }

  soft_delete_enabled = true
}