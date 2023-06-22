output "vm-configs" {
  value = { for instance in module.vms : instance.vm_name => {

    tls_private_key             = nonsensitive(instance.tls_private_key)
    tls_ssh_open_ssh_public_key = instance.tls_public_key_ssh
    private_ip_address          = instance.vm_private_ip_address
    public_ip_address           = instance.vm_public_ip_address
  } }
  sensitive = false
}

