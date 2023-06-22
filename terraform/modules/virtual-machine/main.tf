module "sa_boot_diagnostics" {
  source              = "../storage-account"
  resource_group_name = var.resource_group_name
  location            = var.location
  identifier          = "${var.identifier}bd"
}

# Create (and display) an SSH key
resource "tls_private_key" "this" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_network_interface" "main" {
  name                = "${var.identifier}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.existing.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.create_public_ip ? azurerm_public_ip.this.0.id : null

  }
}

resource "azurerm_public_ip" "this" {
  count               = var.create_public_ip ? 1 : 0
  name                = "publicip-${var.identifier}"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Dynamic"
}


# VM Costs: https://azureprice.net/?region=germanywestcentral&timeoption=month
resource "azurerm_linux_virtual_machine" "this" {
  name                  = "vm-${var.identifier}"
  location              = var.location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.main.id]
  size                  = var.vm_sku

  # os_disk {
  #   name                 = "myOsDisk"
  #   caching              = "ReadWrite"
  #   storage_account_type = "Premium_LRS"
  # }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }

  computer_name                   = "myvm"
  admin_username                  = "azureuser"
  disable_password_authentication = true

  admin_ssh_key {
    username   = "azureuser"
    public_key = tls_private_key.this.public_key_openssh
  }

  boot_diagnostics {
    storage_account_uri = module.sa_boot_diagnostics.primary_blob_endpoint
  }
}


resource "azurerm_private_dns_a_record" "this" {
  count               = var.dns_private_zone_name != null ? 1 : 0
  name                = var.identifier
  zone_name           = var.dns_private_zone_name
  resource_group_name = var.resource_group_name
  ttl                 = 60
  records             = [azurerm_network_interface.main.private_ip_address]
}
