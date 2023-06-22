variable "identifier" {}

variable "resource_group_name" {}

variable "location" {}

variable "tags" {
  type    = map(any)
  default = {}
}

variable "vnet_id" {
  type = string
}

variable "endpoint_outbound_subnets" {
  type = list(object({
    name      = string
    id = string
  }))
  default = []
}
variable "endpoint_inbound_subnets" {
  type = list(object({
    name      = string
    id = string
  }))
  default = []
}



