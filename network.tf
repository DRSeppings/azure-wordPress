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
  tags                = local.default_tags
}

#https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone
resource "azurerm_private_dns_zone" "private_dns_zone" {
  name                = "privatelink.mysql.database.azure.com"
  resource_group_name = azurerm_resource_group.resource_group.name
  tags                = local.default_tags
}

#https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link
resource "azurerm_private_dns_zone_virtual_network_link" "private_dns_zone_vnet_link" {
  name                  = "${var.environment}-${var.project_name}-mysql-dnslink"
  private_dns_zone_name = azurerm_private_dns_zone.private_dns_zone.name
  resource_group_name   = azurerm_resource_group.resource_group.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
}

#https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network
resource "azurerm_virtual_network" "vnet" {
  address_space       = ["10.0.0.0/23"]
  location            = var.location
  name                = "${var.environment}-${var.project_name}-vnet"
  resource_group_name = azurerm_resource_group.resource_group.name
  tags                = local.default_tags
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
}

#https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet
resource "azurerm_subnet" "db_subnet" {
  address_prefixes     = ["10.0.0.128/25"]
  name                 = "${var.environment}-${var.project_name}-dbsubnet"
  resource_group_name  = azurerm_resource_group.resource_group.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  delegation {
    name = "dlg-mysqlFlexibleServer"
    service_delegation {
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
      name    = "Microsoft.DBforMySQL/flexibleServers"
    }
  }
}

# ---------------------------------------------------------------------------
# Network Security Groups
# ---------------------------------------------------------------------------

#https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group
resource "azurerm_network_security_group" "app_nsg" {
  location            = var.location
  name                = "${var.environment}-${var.project_name}-app-nsg"
  resource_group_name = azurerm_resource_group.resource_group.name
  tags                = local.default_tags

  security_rule {
    name                       = "Allow-HTTPS-Inbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-HTTP-Inbound"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-MySQL-Outbound"
    priority                   = 200
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3306"
    source_address_prefix      = "10.0.0.0/25"
    destination_address_prefix = "10.0.0.128/25"
  }
}

#https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group
resource "azurerm_network_security_group" "db_nsg" {
  location            = var.location
  name                = "${var.environment}-${var.project_name}-db-nsg"
  resource_group_name = azurerm_resource_group.resource_group.name
  tags                = local.default_tags

  security_rule {
    name                       = "Allow-MySQL-From-AppSubnet"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3306"
    source_address_prefix      = "10.0.0.0/25"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Deny-All-Other-Inbound"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

#https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association
resource "azurerm_subnet_network_security_group_association" "app_subnet_nsg" {
  subnet_id                 = azurerm_subnet.app_subnet.id
  network_security_group_id = azurerm_network_security_group.app_nsg.id
}

#https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association
resource "azurerm_subnet_network_security_group_association" "db_subnet_nsg" {
  subnet_id                 = azurerm_subnet.db_subnet.id
  network_security_group_id = azurerm_network_security_group.db_nsg.id
}