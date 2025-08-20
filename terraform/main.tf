provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

resource "azurerm_resource_group" "test" {
  name     = "my-vm-test"
  location = "francecentral"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "my-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "my-subnet"
  resource_group_name  = azurerm_resource_group.test.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "public_ip" {
  name                = "my-public-ip"
  resource_group_name = azurerm_resource_group.test.name
  location            = azurerm_resource_group.test.location
  allocation_method   = "Static"
  sku                 = "Standard"
}


resource "azurerm_network_interface" "nic" {
  name                = "my-nic"
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id           = azurerm_public_ip.public_ip.id
  }
}

resource "azurerm_network_security_group" "nsg" {
  name                = "nsg-my-vm-ssh"
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name
}

// Allow SSH (port 22) from my IP (var.my_ip/32)
resource "azurerm_network_security_rule" "allow_ssh_from_my_ip" {
  name                        = "Allow-SSH-From-My-IP"
  resource_group_name         = azurerm_resource_group.test.name
  network_security_group_name = azurerm_network_security_group.nsg.name

  priority                   = 100
  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = "Tcp"
  source_port_range          = "*"
  destination_port_range     = "22"
  source_address_prefix      = "${var.my_ip}/32"
  destination_address_prefix = "*"
  description                = "Allow SSH from my IP only"
}

// Allow HTTP (port 80) from anywhere
resource "azurerm_network_security_rule" "allow_http" {
  name                        = "Allow-HTTP"
  resource_group_name         = azurerm_resource_group.test.name
  network_security_group_name = azurerm_network_security_group.nsg.name

  priority                   = 200
  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = "Tcp"
  source_port_range          = "*"
  destination_port_range     = "80"
  source_address_prefix      = "0.0.0.0/0"
  destination_address_prefix = "*"
  description                = "Allow HTTP from internet"
}

resource "azurerm_network_interface_security_group_association" "nic_nsg_assoc" {
  network_interface_id        = azurerm_network_interface.nic.id
  network_security_group_id   = azurerm_network_security_group.nsg.id
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                  = "my-vm"
  resource_group_name   = azurerm_resource_group.test.name
  location              = azurerm_resource_group.test.location
  size                  = "Standard_B2als_v2"
  admin_username        = "yassine"
  network_interface_ids = [azurerm_network_interface.nic.id]
  admin_ssh_key {
    username   = "yassine"
    public_key = file("/home/yassine/.ssh/id_rsa.pub")
  }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }
}
