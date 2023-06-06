output "tls_private_key" {
  value     = tls_private_key.this.private_key_pem
  sensitive = true
}

output "tls_public_key_ssh" {
  value     = tls_private_key.this.public_key_openssh
}

output "vm_name" {
  value = azurerm_linux_virtual_machine.this.name
}

output "vm_private_ip_address" {
  value = azurerm_network_interface.main.private_ip_address
}
output "vm_public_ip_address" {
  value = var.create_public_ip ? azurerm_public_ip.this.0.ip_address : null
}
