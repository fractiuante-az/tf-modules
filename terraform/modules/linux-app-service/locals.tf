locals {
  hostname= "${var.dns_config.subdomain}.${var.dns_config.zone_name}"
}