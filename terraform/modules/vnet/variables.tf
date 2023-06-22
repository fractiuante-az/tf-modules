variable "identifier" {}

variable "resource_group_name" {}

variable "location" {}

variable "vnet_name_override" {
  default = ""
}


variable "tags" {
  type    = map(any)
  default = {}
}

variable "vnet_cidr" {
  default = "10.0.0.0/16"
}

variable "subnets" {
  default = []
  type = list(object({
    name              = string
    type              = optional(string, "private")
    service_endpoints = optional(list(string), null)
    private_link      = optional(bool, false)
    subnet_delegation = optional(bool, false)
  }))

}

variable "private_dns_zone_name" {
  default = ""
}
