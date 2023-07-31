variable "location" {
  default = "westeurope"
}

variable "identifier" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "bot_web_endpoint" {
  type = string
}

variable "tags" {
  type    = map(any)
  default = {}
}

variable "microsoft_app_id" {
  default = ""
}

variable "microsoft_app_tenant_id" {
  default = ""
}

variable "microsoft_app_type" {
  default = "MultiTenant"
}
