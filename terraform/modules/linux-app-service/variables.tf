variable "dns_config" {
  type = object({
    zone_name           = string
    subdomain           = string
    resource_group_name = string
  })
}

variable "location" {
  default = "westeurope"
}

variable "identifier" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "source_dir_path" {
  type = string
}

variable "app_env_vars" {
  type    = map(any)
  default = {}
}

variable "force_update" {
  default = true
}

variable "tags" {
  type    = map(any)
  default = {}
}
