# Global variables
# Define the variables that will be used in the configuration
variable "project_name" {
    description = "name of the project"
    default = "moth-wordpress"
}

variable "webapp_url_name" {
  description = "Globally unique name for the App Service (<name>.azurewebsites.net)"
}

variable "location" {
  description = "The location where resources will be created"
  default     = "northeurope"
}

variable "environment" {
  description = "Environment (dev, prod)"
  default     = "dev"
}

variable "tags" {
  description = "A map of the tags to use for the resources that are deployed"
  type        = map(string)

  default = {}
}

# Local block for dynamic tags generation
locals {
  default_tags = merge(
    var.tags,
    {
      environment  = var.environment,
      project_name = var.project_name,
      location     = var.location
    }
  )
}

# WordPress web app configuration
variable "wordpress_admin_email" {
  description = "The email address of the WordPress admin user"
}

variable "wordpress_admin_user" {
  description = "The username of the WordPress admin user (avoid 'admin' — it is heavily targeted)"
}

# MySQL flexible server configuration
variable "db_server_admin_login" {
  description = "The username of the MySQL server admin user (avoid 'adminuser' — common in attacks)"
}

# SKU and availability zone configuration
variable "app_service_sku" {
  description = "The SKU name for the App Service Plan"
  default     = "B1"
}

variable "mysql_sku" {
  description = "The SKU name for the MySQL Flexible Server"
  default     = "B_Standard_B1s"
}

variable "mysql_zone" {
  description = "The availability zone for the MySQL Flexible Server"
  default     = "1"
}

variable "mysql_version" {
  description = "The MySQL engine version for the Flexible Server"
  default     = "8.0.21"
}

variable "mysql_backup_retention_days" {
  description = "Number of days to retain automated backups (7–35)"
  default     = 7
}

variable "mysql_geo_redundant_backup" {
  description = "Enable geo-redundant backups for the MySQL Flexible Server"
  default     = false
}
