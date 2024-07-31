location      = "norwayeast"
#fw_license   = "byol"                                                       # Uncomment 1 fw_license to select VM-Series licensing mode
fw_license   = "bundle1"
#fw_license    = "bundle2"
global_prefix = "heiken-"                                                    # Prefix to add to all resource groups created.  This is useful to create unique resource groups within a shared Azure subscription

# -----------------------------------------------------------------------
# VM-Series resource group variables
fw_prefix               = "vmseries"                                         # Adds prefix name to all resources created in the firewall resource group
fw_vm_count             = 1
fw_panos                = "10.2.905"
fw_offer                = "vmseries-flex"
fw_nsg_prefix           = "0.0.0.0/0"
vm_username             = "palo"
vm_password             = "Pal0Alt0"

# -----------------------------------------------------------------------
# Security inbound resource group variables
vmseries_1_prefix          = "palolab"                                         # Adds prefix name to all resources created in the security inbound resource group
vmseries_1_vnet_cidr       = "192.168.0.0/22"
vmseries_1_subnet_names    = ["mgmt", "untrust", "trust"]
vmseries_1_subnet_cidrs    = ["192.168.0.0/24", "192.168.1.0/24", "192.168.2.0/24"]

# -----------------------------------------------------------------------
# Security outbound resource group variables
security_outbound_prefix          = "security-outbound"                                         # Adds prefix name to all resources created in the security outbound resource group
security_outbound_vnet_cidr       = "10.0.0.0/16"
security_outbound_subnet_names    = ["mgmt", "untrust", "trust"]
security_outbound_subnet_cidrs    = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
security_outbound_lb_ip           = "10.0.2.100"

# -----------------------------------------------------------------------
# Virtual WAN spoke variables
spoke_wan_prefix          = "virtual-wan-spoke"                                         # Adds prefix name to all resources created in the WAN spoke resource group
spoke_wan_vnet_cidr       = "10.4.0.0/16"
spoke_wan_subnet_names    = ["default"]
spoke_wan_subnet_cidrs    = ["10.4.0.0/24"]
spoke_wan_vm_count         = 1

# -----------------------------------------------------------------------
# Local spoke VNET variables
spoke_local_prefix          = "local-spoke"                                         # Adds prefix name to all resources created in the local spoke resource group
spoke_local_vnet_cidr       = "10.3.0.0/16"
spoke_local_subnet_names    = ["default"]
spoke_local_subnet_cidrs    = ["10.3.0.0/24"]
spoke_local_vm_count        = 1

# -----------------------------------------------------------------------
# Virtual WAN and virtual hub variables
wan_prefix   = "virtual-wan"                                                        # Adds prefix name to all resources created in the virtual WAN resource group
wan_hub_cidr = "10.10.0.0/24"
