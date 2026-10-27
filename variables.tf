variable "resource_groups" {
  description = "Map of Resource Groups to create"
  type = map(object({
    location = string
    tags     = optional(map(string))
  }))
}

variable "virtual_networks" {
  description = "Map of Virtual Networks"
  type        = any
}

variable "network_security_groups" {
  description = "Map of Network Security Groups with rules"
  type        = any
}

variable "route_tables" {
  description = "Map of Route Tables with routes"
  type        = any
}

variable "hub_vnet_name" {
  description = "Name of the central Hub VNet"
  type        = string
}

variable "hub_vnet_rg" {
  description = "Resource Group of Hub VNet"
  type        = string
}

variable "spoke_vnets" {
  description = "Map of Spoke VNets for peering"
  type = map(object({
    resource_group_name = string
  }))
}

variable "common_tags" {
  description = "Common baseline resource tags"
  type        = map(string)
  default = {
    Environment = "Production"
    ManagedBy   = "Terraform"
    Architect   = "Sujeet Kumar"
    Compliance  = "CIS-v2.0"
  }
}
