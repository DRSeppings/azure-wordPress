# Description: This file contains the terraform code to create a MySQL flexible server and database in Azure.
# The MySQL flexible server is created in the delegated subnet and the database is created in the server.
# The server is associated with a private DNS zone and virtual network link.
# The server is also associated with a user-assigned managed identity.

#https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mysql_flexible_server
resource "azurerm_mysql_flexible_server" "mysql_server" {
  delegated_subnet_id = azurerm_subnet.db_subnet.id
  location            = var.location
  name                = "${var.environment}-${var.project_name}-dbserver"
  private_dns_zone_id = azurerm_private_dns_zone.private_dns_zone.id
  resource_group_name = azurerm_resource_group.resource_group.name
  administrator_login    = var.db_server_admin_login
  administrator_password = random_password.db_server_admin_password.result
  sku_name = var.mysql_sku
  version  = var.mysql_version

  backup_retention_days        = var.mysql_backup_retention_days
  geo_redundant_backup_enabled = var.mysql_geo_redundant_backup

  tags = local.default_tags
  zone = var.mysql_zone
  identity {
    identity_ids = [azurerm_user_assigned_identity.ua_identity.id]
    type         = "UserAssigned"
  }
}

#https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mysql_flexible_server_active_directory_administrator
resource "azurerm_mysql_flexible_server_active_directory_administrator" "mysql_server_ad_admin" {
  identity_id = azurerm_user_assigned_identity.ua_identity.id
  login       = azurerm_user_assigned_identity.ua_identity.name
  object_id   = azurerm_user_assigned_identity.ua_identity.principal_id
  server_id   = azurerm_mysql_flexible_server.mysql_server.id
  tenant_id   = data.azurerm_client_config.current.tenant_id
}

#https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mysql_flexible_database
resource "azurerm_mysql_flexible_database" "mysql_database" {
  charset             = "utf8mb3"
  collation           = "utf8mb3_general_ci"
  name                = "${var.environment}-${var.project_name}-mysql-db"
  resource_group_name = azurerm_resource_group.resource_group.name
  server_name         = azurerm_mysql_flexible_server.mysql_server.name
}