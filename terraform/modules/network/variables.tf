variable "identifier" {}

variable "vnet_name_override" {}

variable "resource_group_name" {}

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
    name = string
    type = optional(string)
  }))

}
