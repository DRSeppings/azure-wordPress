output "app_service_hostname" {
  description = "The default hostname of the WordPress App Service"
  value       = azurerm_linux_web_app.linux_web_app.default_hostname
}

output "mysql_fqdn" {
  description = "The fully qualified domain name of the MySQL Flexible Server"
  value       = azurerm_mysql_flexible_server.mysql_server.fqdn
}

output "resource_group_name" {
  description = "The name of the deployed resource group"
  value       = azurerm_resource_group.resource_group.name
}

output "managed_identity_client_id" {
  description = "The client ID of the user-assigned managed identity"
  value       = azurerm_user_assigned_identity.ua_identity.client_id
}

output "managed_identity_principal_id" {
  description = "The principal ID of the user-assigned managed identity"
  value       = azurerm_user_assigned_identity.ua_identity.principal_id
}
