virtual_network_name = "cmt-poc-vnt-uks"
resource_group_name = "cloud-migration-terraform"
address_prefixes = ["172.19.1.0/24"]
subnet_name = "web_snt_cmt_poc001"
# subnet = {
#   application_gateway_subnet = {
#     name = "appgw_waf_snt_cmt_poc001"
#     address_prefix = "172.19.1.0/24"
#     security_group = ""
#   },
#   app_subnet = {
#     name = "web_snt_cmt_poc001"
#     address_prefix = "172.19.2.0/24"
#     security_group = ""
#   },
#   db_subnet = {
#     name = "db_snt_cmt_poc001"
#     address_prefix = "172.19.3.0/24"
#     security_group = ""
#   }
# }
