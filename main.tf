# Enterprise Azure Landing Zones (CAF Architecture)
# Author: Sujeet Kumar - Senior DevSecOps Engineer & Cloud Architect

terraform {
  required_version = ">= 1.5.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.90.0"
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
    key_vault {
      purge_soft_delete_on_destroy    = false
      recover_soft_deleted_key_vaults = true
    }
  }
}

# 1. Resource Groups via for_each + map
resource "azurerm_resource_group" "rg" {
  for_each = var.resource_groups
  name     = each.key
  location = each.value.location
  tags     = merge(var.common_tags, lookup(each.value, "tags", {}))
}

# 2. Hub and Spoke Virtual Networks with Subnets
module "vnet" {
  source      = "./modules/vnet"
  vnets       = var.virtual_networks
  common_tags = var.common_tags
  depends_on  = [azurerm_resource_group.rg]
}

# 3. Network Security Groups with dynamic security_rule blocks
module "nsg" {
  source      = "./modules/nsg"
  nsgs        = var.network_security_groups
  common_tags = var.common_tags
  depends_on  = [azurerm_resource_group.rg]
}

# 4. Route Tables with dynamic route blocks (UDR forced tunneling)
module "route_table" {
  source       = "./modules/route_table"
  route_tables = var.route_tables
  common_tags  = var.common_tags
  depends_on   = [azurerm_resource_group.rg]
}

# 5. Hub-to-Spoke VNet Peering
resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  for_each                     = var.spoke_vnets
  name                         = "peer-hub-to-${each.key}"
  resource_group_name          = var.hub_vnet_rg
  virtual_network_name         = var.hub_vnet_name
  remote_virtual_network_id    = module.vnet.vnet_ids[each.key]
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = true
  use_remote_gateways          = false
  depends_on                   = [module.vnet]
}

resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  for_each                     = var.spoke_vnets
  name                         = "peer-${each.key}-to-hub"
  resource_group_name          = each.value.resource_group_name
  virtual_network_name         = each.key
  remote_virtual_network_id    = module.vnet.vnet_ids[var.hub_vnet_name]
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false
  depends_on                   = [module.vnet]
}
