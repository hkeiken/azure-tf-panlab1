#-----------------------------------------------------------------------------------------------------------------
# Create security outbound network
resource "azurerm_resource_group" "vmseries_1_rg" {
  name     = "${var.global_prefix}${var.vmseries_1_prefix}-rg"
  location = var.location
}

module "vmseries_1_vnet" {
  source              = "./modules/vnet/"
  name                = "${var.vmseries_1_prefix}-vnet"
  vnet_cidr           = var.vmseries_1_vnet_cidr
  subnet_names        = var.vmseries_1_subnet_names
  subnet_cidrs        = var.vmseries_1_subnet_cidrs
  location            = var.location
  resource_group_name = azurerm_resource_group.vmseries_1_rg.name  
}

#-----------------------------------------------------------------------------------------------------------------
# Create storage account and file share for bootstrapping

resource "random_string" "vmseries_1" {
  length      = 15
  min_lower   = 5
  min_numeric = 10
  special     = false
}

resource "azurerm_storage_account" "vmseries_1_storage" {
  name                     = "${var.vmseries_1_prefix}${random_string.vmseries_1.result}"
  resource_group_name      = azurerm_resource_group.vmseries_1_rg.name
  location                 = azurerm_resource_group.vmseries_1_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

}

module "vmseries_1_fileshare" {
  source               = "./modules/azure_bootstrap/"
  name                 = "${var.vmseries_1_prefix}-bootstrap"
  quota                = 1
  storage_account_name = azurerm_storage_account.vmseries_1_storage.name
  storage_account_key  = azurerm_storage_account.vmseries_1_storage.primary_access_key
  local_file_path      = "/bootstrap/vmseries_1_fw"
}


#-----------------------------------------------------------------------------------------------------------------
# Create VM-Series.  For every fw_name entered, an additional VM-Series instance will be deployed.

module "vmseries_1_fw" {
  source                    = "./modules/vmseries/"
  name                      = "${var.vmseries_1_prefix}-vm"
  resource_group_name      = azurerm_resource_group.vmseries_1_rg.name
  location                 = azurerm_resource_group.vmseries_1_rg.location
  vm_count                  = var.fw_vm_count
  username                  = var.vm_username
  password                  = var.vm_password
  panos                     = var.fw_panos
  license                   = var.fw_license
  nsg_prefix                = var.fw_nsg_prefix
#  avset_name                = "${var.vmseries_1_prefix}-avset"
  subnet_mgmt               = module.vmseries_1_vnet.subnet_ids[0]
  subnet_untrust            = module.vmseries_1_vnet.subnet_ids[1]
  subnet_trust              = module.vmseries_1_vnet.subnet_ids[2]
  nic0_public_ip            = true
  nic1_public_ip            = true
  nic2_public_ip            = false
  nic1_backend_pool_id     = []
  nic2_backend_pool_id     = []
  bootstrap_storage_account = azurerm_storage_account.vmseries_1_storage.name
  bootstrap_access_key      = azurerm_storage_account.vmseries_1_storage.primary_access_key
  bootstrap_file_share      = module.vmseries_1_fileshare.file_share_name
  bootstrap_share_directory = "None"
  
  depends_on = [
    module.vmseries_1_fileshare
  ]
}


#-----------------------------------------------------------------------------------------------------------------
# Create public load balancer.  Load balancer uses firewall's untrust interfaces as its backend pool.

#module "vmseries_1_extlb" {
#  source                  = "./modules/lb/"
#  name                    = "${var.vmseries_1_prefix}-public-lb"
#  resource_group_name      = azurerm_resource_group.vmseries_1_rg.name
#  location                 = azurerm_resource_group.vmseries_1_rg.location
#  type                    = "public"
#  sku                     = "Standard"
#  probe_ports             = [22]
#  frontend_ports          = [80, 22, 443]
#  backend_ports           = [80, 22, 443]
#  protocol                = "Tcp"
#  network_interface_ids   = module.vmseries_1_fw.nic1_id
#}



output MGMT-FW {
  value = "https://${module.vmseries_1_fw.nic0_public_ip[0]}"
}

output CLIENT {
  value = "https://${module.vmseries_1_fw.nic1_public_ip[0]}"
}
