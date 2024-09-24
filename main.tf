# Description: This file contains the main configuration for the Terraform deployment
# The configuration creates a resource group, a virtual network, a subnet, a private
# DNS zone, a private DNS zone virtual network link, a MySQL flexible server, a MySQL
# flexible database, a user-assigned managed identity, a service plan, and a Linux web app.
# The Linux web app is associated with the MySQL flexible server and database. 


#https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/service_plan
resource "azurerm_service_plan" "service_plan" {
  location            = var.location
  name                = "${var.environment}-${var.project_name}-asp"
  os_type             = "Linux"
  resource_group_name = azurerm_resource_group.resource_group.name
  sku_name            = "B1"
  tags = var.tags
  depends_on = [
    azurerm_resource_group.resource_group,
  ]
}

#https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_web_app
resource "azurerm_linux_web_app" "linux_web_app" {
  app_settings = {
    DATABASE_HOST                         = azurerm_mysql_flexible_server.mysql_server.fqdn  
    DATABASE_NAME                         = azurerm_mysql_flexible_database.mysql_database.name  
    DATABASE_USERNAME                     = azurerm_user_assigned_identity.ua_identity.name      
    ENABLE_MYSQL_MANAGED_IDENTITY         = "true"
    SETUP_PHPMYADMIN                      = "true"
    WEBSITES_CONTAINER_START_TIME_LIMIT   = "1800"
    WEBSITES_ENABLE_APP_SERVICE_STORAGE   = "true"
    WORDPRESS_LOCALE_CODE                 = "en_US"
    WORDPRESS_LOCAL_STORAGE_CACHE_ENABLED = "true"
  }
  location            = var.location
  name                = "${var.webapp_url_name}"
  resource_group_name = azurerm_resource_group.resource_group.name
  service_plan_id     = azurerm_service_plan.service_plan.id
  tags = var.tags
  virtual_network_subnet_id = azurerm_subnet.app_subnet.id  
  connection_string {
    name  = "WORDPRESS_ADMIN_EMAIL"
    type  = "Custom"
    value = var.wordpress_admin_email
  }
  connection_string {
    name  = "WORDPRESS_ADMIN_PASSWORD"
    type  = "Custom"
    value = var.wordpress_admin_password
  }
  connection_string {
    name  = "WORDPRESS_ADMIN_USER"
    type  = "Custom"
    value = var.wordpress_admin_user
  }
  identity {
    identity_ids = [azurerm_user_assigned_identity.ua_identity.id]
    type         = "UserAssigned"
  }
  site_config {
    ftps_state                        = "FtpsOnly"
  }
  depends_on = [
    azurerm_user_assigned_identity.ua_identity,
    azurerm_subnet.app_subnet,
    azurerm_service_plan.service_plan,
  ]
}