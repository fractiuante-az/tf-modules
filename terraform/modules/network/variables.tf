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
    name = string
    type = optional(string)
  }))

}
