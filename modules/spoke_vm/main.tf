resource "azurerm_network_security_group" "main" {
  name                = "${var.name}-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "data-inbound"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "data-outbound"
    priority                   = 1000
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

}

#-----------------------------------------------------------------------------------------------------------------
# Create public IPs (optional)
resource "azurerm_public_ip" "main" {
  count               = var.public_ip ? var.vm_count : 0
  name                = "${var.name}${count.index + 1}-nic0-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = var.public_ip_address_allocation
  sku                 = var.public_ip_sku
}

resource "azurerm_network_interface" "main" {
  count                     = var.vm_count
  name                      = "${var.name}${count.index + 1}-nic0"
  location                  = var.location
  resource_group_name       = var.resource_group_name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = var.subnet_id
    #private_ip_address_allocation = "Dynamic"
    private_ip_address_allocation = "Static"
    private_ip_address            = "192.168.2.5"
#    public_ip_address_id          = var.public_ip ? element(concat(azurerm_public_ip.main.*.id, list("")), count.index) : ""
  }
}


resource "azurerm_network_interface_security_group_association" "main" {
  count                     = var.vm_count
  network_interface_id      = element(azurerm_network_interface.main.*.id, count.index)
  network_security_group_id = azurerm_network_security_group.main.id
  depends_on = [
    azurerm_virtual_machine.main
  ]
}

data "template_cloudinit_config" "config" {
  gzip          = true
  base64_encode = true

  # Main cloud-config configuration file.
  part {
    content_type = "text/cloud-config"
    content      =  file("${path.module}/bootstrap/client_vm/cloud_init")
  }
}

resource "azurerm_virtual_machine" "main" {
  count                            = var.vm_count
  name                             ="${var.name}${count.index + 1}"
  location                         = var.location
  resource_group_name              = var.resource_group_name
  network_interface_ids            = [element(azurerm_network_interface.main.*.id, count.index)]
  vm_size                          = "Standard_B1s"
  availability_set_id              = var.availability_set_id
  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true
  

  storage_image_reference {
    publisher = var.publisher
    offer     = var.offer
    sku       = var.sku
    version   = "latest"
  }

  storage_os_disk {
    name              = "${var.name}${count.index + 1}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "${var.name}${count.index + 1}"
    admin_username = var.username
    admin_password = var.password
    custom_data    = data.template_cloudinit_config.config.rendered
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = var.tags
  depends_on = [
    azurerm_network_interface.main
  ]
}

# resource "azurerm_network_interface_backend_address_pool_association" "main" {
#   count                   = length(var.backend_pool_id) != 0 ? var.vm_count : 0
#   network_interface_id    = element(azurerm_network_interface.main.*.id, count.index)
#   ip_configuration_name   = "ipconfig1"
#   backend_address_pool_id = element(var.backend_pool_id, 0)

#   depends_on = [
#     azurerm_virtual_machine.main
#   ]
# }