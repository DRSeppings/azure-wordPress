# Global variables
# Define the variables that will be used in the configuration
variable "project_name" {
    description = "name of the project"
    default = "moth-wordpress"
}

variable "webapp_url_name" {
    description = "name of the webapp"
    default = "moth-wordpress"
  
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
  default     = "test@testing.com"  
}

variable "wordpress_admin_password" {
  description = "The password of the WordPress admin user"
  default     = "P@ssword1234!"
}

variable "wordpress_admin_user" {
  description = "The username of the WordPress admin user"
  default     = "admin"
}


# mysql_flexible_server configuration
variable "db_server_admin_login" {
  description = "The username of the MySQL server admin user"
  default     = "adminuser"
}

variable "db_server_admin_password" {
  description = "The password of the MySQL server admin user"
  default     = "P@ssword1234"
}

