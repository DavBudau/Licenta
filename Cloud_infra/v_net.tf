resource "azurerm_network_security_group" "pwp_sg" {
  name                = "pwp-sg"
  location            = data.azurerm_resource_group.pwp_rg.location
  resource_group_name = data.azurerm_resource_group.pwp_rg.name

  security_rule {
    name                       = "AllowHTTP"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowSSH"
    priority                   = 102
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_virtual_network" "pwp_vn" {
  name                = "pwp-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = data.azurerm_resource_group.pwp_rg.location
  resource_group_name = data.azurerm_resource_group.pwp_rg.name
}

resource "azurerm_subnet_network_security_group_association" "pwp_snsg_f" {
  subnet_id                 = azurerm_subnet.pwp_subnet_frontend.id
  network_security_group_id = azurerm_network_security_group.pwp_sg.id
}

resource "azurerm_subnet_network_security_group_association" "pwp_snsg_b" {
  subnet_id                 = azurerm_subnet.pwp_subnet_backend.id
  network_security_group_id = azurerm_network_security_group.pwp_sg.id
}

resource "azurerm_subnet" "pwp_subnet_backend" {
  name                 = "pwp-subnet-backend"
  resource_group_name  = data.azurerm_resource_group.pwp_rg.name
  virtual_network_name = azurerm_virtual_network.pwp_vn.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "pwp_subnet_frontend" {
  name                 = "pwp-subnet-frontend"
  resource_group_name  = data.azurerm_resource_group.pwp_rg.name
  virtual_network_name = azurerm_virtual_network.pwp_vn.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "pwp_public_ip_backend" {
  name                = "pwp-public-ip-backend"
  resource_group_name = data.azurerm_resource_group.pwp_rg.name
  location            = data.azurerm_resource_group.pwp_rg.location
  allocation_method   = "Static"
}

resource "azurerm_public_ip" "pwp_public_ip_frontend" {
  name                = "pwp-public-ip-frontend"
  resource_group_name = data.azurerm_resource_group.pwp_rg.name
  location            = data.azurerm_resource_group.pwp_rg.location
  allocation_method   = "Static"
}