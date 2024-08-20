#Managed Identity Creation
# resource "azurerm_user_assigned_identity" "mssql_server_mi" {
#   resource_group_name = var.resource_group_name
#   location            = var.location
#   name                = "${var.mssql_server_name}-identity"
# }


resource "azurerm_mssql_server" "mssql_server" {
  name                         = var.mssql_server_name
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = "12.0"
  administrator_login          = var.administrator_login
  administrator_login_password = var.administrator_login_password
  minimum_tls_version          = "1.2"
  # primary_user_assigned_identity_id = azurerm_user_assigned_identity.mssql_server_mi.id
  # identity {
  #   identity_ids = [ azurerm_user_assigned_identity.mssql_server_mi.id ]
  #   type = "UserAssigned"
  # }

  # azuread_administrator {
  #   login_username = var.login_username
  #   object_id      = var.object_id
  # }
}

resource "azurerm_mssql_database" "mssql_database" {
  name           = var.mssql_database_name
  server_id      = azurerm_mssql_server.mssql_server.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  auto_pause_delay_in_minutes = -1
  max_size_gb    = var.max_size_gb
  sku_name       = "GP_S_Gen5_2"
  zone_redundant = false
  enclave_type   = "VBS"
  min_capacity = var.min_capacity
  lifecycle {
    prevent_destroy = true
  }
}

#CREATE PRIVATE EP
# data "azurerm_subnet" "pe_subnet" {
#   name = var.private_endpoint_subnet_name
#   virtual_network_name = var.virtual_network_name
#   resource_group_name = var.resource_group_name
# }

# data "azurerm_private_dns_zone" "private_dns_zone" {
#   name = var.private_dns_name
# }


# resource "azurerm_private_endpoint" "private_endpoint" {
#   name                = "${var.mssql_server_name}-endpoint"
#   location            = var.location
#   resource_group_name = var.resource_group_name
#   subnet_id           = data.azurerm_subnet.pe_subnet.id
  

#   private_service_connection {
#     name                           = "${var.mssql_server_name}-privateconnection"
#     private_connection_resource_id = azurerm_mssql_server.mssql_server.id #basically resource ID
#     subresource_names = [var.sub_resource_name]
#     is_manual_connection = false
#   }

#   private_dns_zone_group {
#     name = "${var.mssql_server_name}-dzg"
#     private_dns_zone_ids = [data.azurerm_private_dns_zone.private_dns_zone.id]
#   }
# }
