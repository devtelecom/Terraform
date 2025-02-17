# Configuring Resource Group
resource "azurerm_resource_group" "myrg" {
  name     = "infra"
  location = local.resource_location
}
# Configure Virtual Network
resource "azurerm_virtual_network" "myvirtualnw" {
  name                = local.vnet.name
  location            = local.resource_location
  resource_group_name = azurerm_resource_group.myrg.name
  address_space       = local.vnet.vnet_range
  dns_servers         = ["192.168.0.4", "192.168.0.5"]
  depends_on          = [ azurerm_resource_group.myrg ]
}
#create Subnet
resource "azurerm_subnet" "mysubnetapp" {
  name                 = local.subnet.name
  resource_group_name  = azurerm_resource_group.myrg.name
  virtual_network_name = azurerm_virtual_network.myvirtualnw.name
  address_prefixes     = local.subnet.range
}
# Create network interface
resource "azurerm_network_interface" "mynwint" {
  name                = "app-interface"
  location            = local.resource_location
  resource_group_name = azurerm_resource_group.myrg.name
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.mysubnetapp.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.mypubip.id
  }
}
# Create a public IP
resource "azurerm_public_ip" "mypubip" {
  name                    = "Infra-Pip"
  location                = local.resource_location
  resource_group_name     = azurerm_resource_group.myrg.name
  allocation_method       = "Static"
  idle_timeout_in_minutes = 30
}
# Create an NSG group
resource "azurerm_network_security_group" "my-nsg" {
  name                = "App-snet-nsg"
  location            = local.resource_location
  resource_group_name = azurerm_resource_group.myrg.name
  security_rule {
    name                       = "Allow-SSH"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}
# Associate NSG with Subnet
resource "azurerm_subnet_network_security_group_association" "mynsgassocinfra" {
  subnet_id                = azurerm_subnet.mysubnetapp.id
  network_security_group_id = azurerm_network_security_group.my-nsg.id
}
# Output Public IP
output "public_ip" {
  value = azurerm_public_ip.mypubip.ip_address
}
/*
resource "azurerm_subnet" "mysubnetinfra" {
  name                 = local.subnets[0].name
  resource_group_name  = azurerm_resource_group.myrg.name
  virtual_network_name = azurerm_virtual_network.myvirtualnw.name
  address_prefixes     = local.subnets[0].subnet_range
}
*/
# Create Virtual Machine
resource "azurerm_linux_virtual_machine" "myvm" {
  name                = "App-vm"
  resource_group_name = azurerm_resource_group.myrg.name
  location            = local.resource_location
  size                = "Standard_DS3"
  admin_username      = "shivam"
  network_interface_ids = [
    azurerm_network_interface.mynwint.id,
  ]
  admin_ssh_key {
    username   = "shivam"
    public_key = file("~/.ssh/shivam.pub")
  }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18_04-lts-gen2"
    version   = "latest"
  }
}