variable location {
  description = "Enter a location"
}

variable fw_prefix {
  description = "Prefix to add to all resources added in the firewall resource group"
  default     = ""
}

variable fw_license {
  description = "VM-Series license: byol, bundle1, or bundle2"
  # default = "byol"   
  # default = "bundle1"  
  # default = "bundle2"
}

variable fw_offer {
  description = "VM-Series marketplace offer name. vmseries-flex for post PAN-OS 9.1.  vmseries1 for pre PAN-OS 9.1."
}

variable global_prefix {
  description = "Prefix to add to all resource groups created.  This is useful to create unique resource groups within a shared Azure subscription"
}
#-----------------------------------------------------------------------------------------------------------------
# Security inbound variables

variable vmseries_1_prefix {
}

variable vmseries_1_vnet_cidr {
}

variable vmseries_1_subnet_names {
  type = list(string)
}

variable vmseries_1_subnet_cidrs {
  type = list(string)
}

#-----------------------------------------------------------------------------------------------------------------
# Security outbound variables

variable security_outbound_prefix {
}

variable security_outbound_vnet_cidr {
}

variable security_outbound_subnet_names {
  type = list(string)
}

variable security_outbound_subnet_cidrs {
  type = list(string)
}

#-----------------------------------------------------------------------------------------------------------------
# Virtual WAN spoke variables

variable spoke_wan_prefix {
}

variable spoke_wan_vnet_cidr {
}

variable spoke_wan_subnet_names {
  type = list(string)
}

variable spoke_wan_subnet_cidrs {
  type = list(string)
}

variable spoke_wan_vm_count {
}
#-----------------------------------------------------------------------------------------------------------------
# Virtual WAN spoke variables

variable spoke_local_prefix {
}

variable spoke_local_vnet_cidr {
}

variable spoke_local_subnet_names {
  type = list(string)
}

variable spoke_local_subnet_cidrs {
  type = list(string)
}

variable spoke_local_vm_count {
}
#-----------------------------------------------------------------------------------------------------------------
# Virtual WAN & virtual hub variables

variable "wan_prefix" {
}

variable "wan_hub_cidr" {
}


#-----------------------------------------------------------------------------------------------------------------
# VM-Series variables

variable fw_vm_count {
}

variable fw_nsg_prefix {
}

variable fw_panos {
}

variable vm_username {
}

variable vm_password {
}

variable security_outbound_lb_ip {
}

#-----------------------------------------------------------------------------------------------------------------
# Spoke variables

variable tags {
  description = "The tags to associate with newly created resources"
  type        = map(string)

  default = {
    trusted-resource = "yes"
    allow-internet   = "yes"
  }
}