variable "resource_group_name" {
  type = string
  description = "Name of the resource group"
  default = null
}

variable "virtual_network_name" {
  type = string
  description = "Name of the virtual network"
  default = null
}

variable "address_space" {
  type = string
  description = "CIDR address space"
  default = null
}

variable "location" {
  type = string
  description = "Location of the resource group"
  default = null
}

# variable "subnet" {
#   type = map(object({
#     name = string
#     address_prefix = string
#     security_group = string
#   }))
#   default = {}
# }


