variable "resource_group_name" {
  type = string
  description = "Name of the resource group"
  default = null
}

variable "storage_account_name" {
  type = string
  description = "Name of the virtual network"
  default = null
}

variable "location" {
  type = string
  description = "Location of the resource group"
  default = null
}

variable "account_replication_type" {
  type = string
  description = "Name of the resource group"
  default = "sqlServer"
}

variable "account_tier" {
   type = string
   description = "Name of the resource group"
}
