variable "location" {
  default = "westeurope"
}

variable "identifier" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "tags" {
  type    = map(any)
  default = {}
}

variable "maintenance_window" {
  description = "Map of maintenance window configuration."
  type        = map(number)
  default     = null
}

variable "private_dns_zone_id" {
  description = "ID of the private DNS zone to create the PostgreSQL Flexible Server."
  type        = string
  default     = null
}

variable "delegated_subnet_id" {
  description = "Id of the subnet to create the PostgreSQL Flexible Server. (Should not have any resource deployed in)"
  type        = string
  default     = null
}

variable "backup_retention_days" {
  description = "Backup retention days for the PostgreSQL Flexible Server (Between 7 and 35 days)."
  type        = number
  default     = 7
}

variable "geo_redundant_backup_enabled" {
  description = "Enable Geo Redundant Backup for the PostgreSQL Flexible Server."
  type        = bool
  default     = false
}

variable "azure_extensions" {
  default = null # "CUBE,CITEXT,BTREE_GIST"
  type    = string
}


variable "administrator_login" {
  default = "psqladmin"
}
variable "administrator_password" {
  default = "H@Sh1CoR3!"
}
