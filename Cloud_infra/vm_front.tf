resource "azurerm_linux_virtual_machine" "pwp_vm_frontend" {
  name                            = "pwp-vm-frontend"
  location                        = data.azurerm_resource_group.pwp_rg.location
  resource_group_name             = data.azurerm_resource_group.pwp_rg.name
  size                            = "Standard_B1ls"
  admin_username                  = "azureuser"
  disable_password_authentication = true

  network_interface_ids = [
    azurerm_network_interface.pwp_nic_frontend.id,
  ]

#   admin_ssh_key {
#     username   = "azureuser"
#     public_key = var.frontend_ssh_key
#   }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }
}

resource "azurerm_network_interface" "pwp_nic_frontend" {
  name                = "pwp-nic-frontend"
  resource_group_name = data.azurerm_resource_group.pwp_rg.name
  location            = data.azurerm_resource_group.pwp_rg.location

  ip_configuration {
    name                          = "pwp-ipconf-frontend"
    subnet_id                     = azurerm_subnet.pwp_subnet_frontend.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pwp_public_ip_frontend.id
  }
}