#Managed Identity Creation
# resource "azurerm_user_assigned_identity" "vm_server_mi" {
#   resource_group_name = var.resource_group_name
#   location            = var.location
#   name                = "${var.kv_name}-identity"
# }

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }
}

data "azurerm_client_config" "current" {}


resource "azurerm_key_vault" "keyvault" {
  name                        = var.kv_name
  location                    = var.location
  resource_group_name         = var.resource_group_name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get",
    ]

    secret_permissions = [
      "Get",
    ]

    storage_permissions = [
      "Get",
    ]
  }
}



# #CREATE PRIVATE EP
# data "azurerm_subnet" "pe_subnet" {
#   name = var.private_endpoint_subnet_name
#   virtual_network_name = var.virtual_network_name
#   resource_group_name = var.resource_group_name
# }

# data "azurerm_private_dns_zone" "private_dns_zone" {
#   name = var.private_dns_name
# }


# resource "azurerm_private_endpoint" "private_endpoint" {
#   name                = "${var.kv_name}-endpoint"
#   location            = var.location
#   resource_group_name = var.resource_group_name
#   subnet_id           = data.azurerm_subnet.pe_subnet.id
  

#   private_service_connection {
#     name                           = "${var.kv_name}-privateconnection"
#     private_connection_resource_id = azurerm_key_vault.keyvault.id #basically resource ID
#     subresource_names = [var.sub_resource_name]
#     is_manual_connection = false
#   }

#   private_dns_zone_group {
#     name = "${var.kv_name}-dzg"
#     private_dns_zone_ids = [data.azurerm_private_dns_zone.private_dns_zone.id]
#   }
# }
