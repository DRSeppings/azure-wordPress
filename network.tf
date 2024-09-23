# Description: This file contains the code to create the network resources in Azure.
# The configuration creates a resource group, a virtual network, a subnet, a private DNS zone, and a private DNS zone virtual network link.
# The subnet is delegated to the Microsoft.Web/serverFarms and Microsoft.DBforMySQL/flexibleServers services.
# The private DNS zone is created for the MySQL flexible server.
# The private DNS zone virtual network link is created to link the virtual network to the private DNS zone.


#https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity
resource "azurerm_user_assigned_identity" "ua_identity" {
  location            = var.location
  name                = "${var.environment}-${var.project_name}-wpidentity"
  resource_group_name = azurerm_resource_group.resource_group.name
  tags = var.tags
  depends_on = [
    azurerm_resource_group.resource_group,
  ]
}

#https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone
resource "azurerm_private_dns_zone" "private_dns_zone" {
  name                = "${var.environment}-${var.project_name}-privatelink.mysql.database.azure.com"
  resource_group_name = azurerm_resource_group.resource_group.name
  tags = var.tags
  depends_on = [
    azurerm_resource_group.resource_group,
  ]
}

#https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link
resource "azurerm_private_dns_zone_virtual_network_link" "private_dns_zone_vnet_link" {
  name                  = "${azurerm_private_dns_zone.private_dns_zone.name}-vnetlink"
  private_dns_zone_name = azurerm_private_dns_zone.private_dns_zone.name
  resource_group_name   = azurerm_resource_group.resource_group.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
  depends_on = [
    azurerm_private_dns_zone.private_dns_zone,
    azurerm_virtual_network.vnet,
  ]
}

#https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network
resource "azurerm_virtual_network" "vnet" {
  address_space       = ["10.0.0.0/23"]
  location            = var.location
  name                = "${var.environment}-${var.project_name}-vnet"
  resource_group_name = azurerm_resource_group.resource_group.name
  tags = var.tags
  depends_on = [
    azurerm_resource_group.resource_group,
  ]
}

#https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet
resource "azurerm_subnet" "app_subnet" {
  address_prefixes     = ["10.0.0.0/25"]
  name                 = "${var.environment}-${var.project_name}-appsubnet"
  resource_group_name  = azurerm_resource_group.resource_group.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  delegation {
    name = "dlg-appService"
    service_delegation {
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
      name    = "Microsoft.Web/serverFarms"
    }
  }
  depends_on = [
    azurerm_virtual_network.vnet,
  ]
}

#https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet
resource "azurerm_subnet" "db_subnet" {
  address_prefixes     = ["10.0.0.128/25"]
  name                 = "${var.environment}-${var.project_name}-dbsubnet"
  resource_group_name  = azurerm_resource_group.resource_group.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  delegation {
    name = "dlg-appService"
    service_delegation {
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
      name    = "Microsoft.DBforMySQL/flexibleServers"
    }
  }
  depends_on = [
    azurerm_virtual_network.vnet,
  ]
}