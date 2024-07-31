#-----------------------------------------------------------------------------------------------------------------
# Create local spoke VNET that will be peered to the security outbound VNET
#resource "azurerm_resource_group" "spoke_local_rg" {
#  name     = "${var.global_prefix}${var.spoke_local_prefix}-rg"
#  location = var.location
#}

#module "spoke_local_vnet" {
#  source              = "./modules/vnet/"
#  name                = "${var.spoke_local_prefix}-vnet"
#  vnet_cidr           = var.spoke_local_vnet_cidr
#  subnet_names        = var.spoke_local_subnet_names
#  subnet_cidrs        = var.spoke_local_subnet_cidrs
#  location            = var.location
#  resource_group_name = azurerm_resource_group.vmseries_1_rg.name
#  route_table_ids     = [azurerm_route_table.spoke_local_rtb.id]
#}#
#
#resource "azurerm_virtual_network_peering" "spoke_local_to_security_outbound" {
#  name                         = "${var.spoke_local_prefix}-vnet-${var.security_outbound_prefix}-vnet"
#  resource_group_name          = azurerm_resource_group.spoke_local_rg.name
#  virtual_network_name         = module.spoke_local_vnet.vnet_name
#  remote_virtual_network_id    = module.security_outbound_vnet.vnet_id
#  allow_virtual_network_access = true
#  allow_forwarded_traffic      = true
#}

#resource "azurerm_virtual_network_peering" "security_outbound_to_spoke1" {
#  name                         = "${var.security_outbound_prefix}-vnet-${var.spoke_local_prefix}-vnet"
#  resource_group_name          = azurerm_resource_group.security_outbound_rg.name
#  virtual_network_name         = module.security_outbound_vnet.vnet_name
#  remote_virtual_network_id    = module.spoke_local_vnet.vnet_id
#  allow_virtual_network_access = true
#  allow_forwarded_traffic      = true
#}


#resource "azurerm_route_table" "spoke_local_rtb" {
#  name                          = "${var.spoke_local_prefix}-rtb"
#  location                      = azurerm_resource_group.spoke_local_rg.location
#  resource_group_name           = azurerm_resource_group.spoke_local_rg.name
#  disable_bgp_route_propagation = true

#  route {
#    name                   = "route0"
#    address_prefix         = "0.0.0.0/0"
#    next_hop_type          = "VirtualAppliance"
#    next_hop_in_ip_address = var.security_outbound_lb_ip
#  }
#  route {
#    name                   = "route1"
#    address_prefix         = "10.0.0.0/8"
#    next_hop_type          = "VirtualAppliance"
#    next_hop_in_ip_address = var.security_outbound_lb_ip
#  }
#  route {
#    name                   = "route2"
#    address_prefix         = "172.16.0.0/12"
#    next_hop_type          = "VirtualAppliance"
#    next_hop_in_ip_address = var.security_outbound_lb_ip
#  }
#  route {
#    name                   = "route3"
#    address_prefix         = "192.168.0.0/16"
#    next_hop_type          = "VirtualAppliance"
#    next_hop_in_ip_address = var.security_outbound_lb_ip
#  }
#
#}

resource "azurerm_route_table" "spoke_local_rtb" {
  name                          = "${var.spoke_local_prefix}-rtb"
  location                      = azurerm_resource_group.vmseries_1_rg.location
  resource_group_name           = azurerm_resource_group.vmseries_1_rg.name
  disable_bgp_route_propagation = true

  route {
    name                   = "route0"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "192.168.2.4"
  }
}

resource "azurerm_subnet_route_table_association" "trust_rtb" {
  subnet_id      = module.vmseries_1_vnet.subnet_ids[2]
  route_table_id = azurerm_route_table.spoke_local_rtb.id
}

data "template_cloudinit_config" "config" {
  gzip          = true
  base64_encode = true

  # Main cloud-config configuration file.
  part {
    content_type = "text/cloud-config"
    content      = "packages: ['httpie']"
  }
}

module "spoke_local_vm" {
  source              = "./modules/spoke_vm/"
  name                = "${var.spoke_local_prefix}-vm"
  resource_group_name = azurerm_resource_group.vmseries_1_rg.name
  location            = var.location
  vm_count            = var.spoke_local_vm_count
  subnet_id           = module.vmseries_1_vnet.subnet_ids[2]
  availability_set_id = ""
  #publisher           = "Canonical"
  #offer               = "UbuntuServer"
  #sku                 = "16.04-LTS"
  publisher           = "debian"
  offer               = "debian-12"
  sku                 = "12-gen2"
  username            = var.vm_username
  password            = var.vm_password
  tags                = var.tags
}