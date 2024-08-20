# data "azurerm_subnet" "appgw_subnet" {
#   name = var.appgw_subnet_name
#   virtual_network_name = var.virtual_network_name
#   resource_group_name = var.resource_group_name
# }

#CREATE IDENTITY
# resource "azurerm_user_assigned_identity" "user_assigned_identity" {
#   location            = var.location
#   name                = "${var.app_gateway_name}-identity" 
#   resource_group_name = var.resource_group_name
# }
#CREATE PUBLIC IP
resource "azurerm_public_ip" "public_ip" {
  name                =  var.appgw_public_ip
  sku                 = "Standard"
  location            =  var.location
  resource_group_name =  var.resource_group_name
  domain_name_label =    var.domain_name_label
  allocation_method   = "Static"
}


#CREATE APP GATEWAY
resource "azurerm_application_gateway" "app_gateway" {
  name                = var.app_gateway_name
  resource_group_name =  var.resource_group_name
  location            = var.location

  sku {
    name     = var.sku_name
    tier     = var.sku_tier
    capacity = 2
  }

  gateway_ip_configuration {
    name      = var.appgw_congif_pip
    subnet_id = var.subnet_id
  }

  frontend_port {
    name = var.frontend_port_name
    port = 80
  }

  # identity {
  #   type = "UserAssigned"
  #   identity_ids = [azurerm_user_assigned_identity.user_assigned_identity.id]
  # }

  frontend_ip_configuration {
    name                 = var.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.public_ip.id
  }

  backend_address_pool {
    name = var.backend_address_pool_name
  }

  backend_http_settings {
    name                  = var.http_setting_name
    cookie_based_affinity = "Disabled"
    path                  = "/"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }

  http_listener {
    name                           = var.listener_name
    frontend_ip_configuration_name = var.frontend_ip_configuration_name
    frontend_port_name             = var.frontend_port_name
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = var.request_routing_rule_name
    priority                   = 9
    rule_type                  = "Basic"
    http_listener_name         = var.listener_name
    backend_address_pool_name  = var.backend_address_pool_name
    backend_http_settings_name = var.http_setting_name
  }
}