variable "resource_group_name" {
  description = "RG name"
  default = "rg-uks-gen-dev001"
}

variable "location" {
  description = "RG location"
  default = "UK South"
}

variable "app_gateway_name" {
  description = "app_gateway_name"
}

variable "appgw_subnet_name" {
  description = "subnet_name"
  # default = "default"
}

variable "sku_name" {
  description = "sku_name"
  # default = "nic-uks-vm-dev001"
}

variable "subnet_id" {
  
}

variable "sku_tier" {
  description = "sku_tier"
  # default = "nic-uks-vm-dev001"
}
variable "appgw_congif_pip" {
  description = "appgw_congif_pip"
  # default = "nic-uks-vm-dev001"
}

variable "domain_name_label" {
  description = "domain_name_label"
  # default = "ip_config"
}
# variable "identity_name" {
#   description = "domain_name_label"
#   # default = "ip_config"
# }

variable "frontend_port_name" {
  description = "frontend_port_name"
  # default = "pip-uks-gen-dev001"
}

variable "frontend_ip_configuration_name" {
  description = "frontend_ip_configuration_name"
  # default = "vm-uks-gen-dev001"
}

variable "backend_address_pool_name" {
  description = "backend_address_pool_name"
  # default = "Standard_DS1_v2"
}

variable "http_setting_name" {
  description = "http_setting_name"
  # default = "elboj_admin"
}

variable "listener_name" {
  description = "listener_name"
  # default = "__VM_PASSWORD__"
}

variable "request_routing_rule_name"{
  description = "request_routing_rule_name"
  # default = "storage_account_type"
}

variable "appgw_public_ip"{
  description = "appgw_public_ip"
  # default = "disk_size_gb"
}

variable "virtual_network_name" {
  description = "virtual_network_name"
  # default = "managed_disk_name"
}
