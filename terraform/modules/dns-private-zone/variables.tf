variable "identifier" {}

variable "resource_group_name" {
  type = string
}
variable "domain" {
  type    = string
  default = "vpn-domain.de"
}

variable "link_virtual_network_id" {
  default = ""
}
variable "tags" {
  type    = map(any)
  default = {}
}
