variable "resource_group_name" {
  type = string
  description = "Name of the resource group"
  default = null
}

variable "kv_name" {
  type = string
  description = "Name of the virtual network"
  default = null
}

variable "location" {
  type = string
  description = "Location of the resource group"
  default = null
}

#Private EP
variable "sub_resource_name" {
  type = string
  description = "Name of the resource group"
  default = "sqlServer"
}

variable "private_dns_name" {
  type = string
  description = "Name of the resource group"
  default = "privatelink.database.windows.net"
}

variable "private_endpoint_subnet_name" {
   type = string
   description = "Name of the resource group"
}

variable "virtual_network_name" {
   type = string
   description = "Name of the resource group"
}

