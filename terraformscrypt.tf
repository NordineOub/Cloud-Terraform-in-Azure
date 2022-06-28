terraform { 
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}

  subscription_id = "765266c6-9a23-4638-af32-dd1e32613047"
}
resource "azurerm_public_ip" "public_ip" {
  name                = "devops-20200174" 
  resource_group_name = "devops-TP2"
  location            = "francecentral"
  allocation_method   = "Dynamic"

}
 
resource "azurerm_subnet" "internal" {
  name                = "internal" 
  resource_group_name = "devops-TP2"
  virtual_network_name = "example-network"
  address_prefixes     = ["10.3.1.0/24"]
}

resource "azurerm_network_interface" "main" {
  name                = "devops-20200174" 
  resource_group_name = "devops-TP2"
  location            = "francecentral"

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id

  }
}


# Create (and display) an SSH key
resource "tls_private_key" "example_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}


resource "azurerm_linux_virtual_machine" "main" {
  name                = "devops-20200174" 
  resource_group_name = "devops-TP2"
  location            = "francecentral"
  network_interface_ids = [azurerm_network_interface.main.id]
  size             = "Standard_D2s_v3"


    computer_name  = "hostname"
    admin_username = "devops"
  disable_password_authentication = true
 source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
 os_disk {
    name              = "mon_disque_os"
    caching           = "ReadWrite"
    # create_option     = "FromImage"
    storage_account_type  = "Standard_LRS"
  }


  admin_ssh_key {
    username   = "devops"
    public_key = tls_private_key.example_ssh.public_key_openssh
  }
}
  
