variable "resource_group_name" {
  type = string
  description = "Name of the resource group"
}


variable "mssql_server_name" {
  description = "mssql_server_name"
}

variable "administrator_login" {
  description = "administrator_login"
}

variable "administrator_login_password" {
  description = "administrator_login_password"
}

variable "location" {
  description = "SKU type for SP"
}

variable "mssql_database_name" {
  description = "mssql_database_name"
}

variable "min_capacity" {
  description = "min_capacity"
  default = 1
}

variable "max_size_gb" {
  description = "max_size_gb"
  default = 32
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