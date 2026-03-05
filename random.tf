# Generate a random password for the WordPress admin user
resource "random_password" "wordpress_admin_password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

# Generate a random password for the MySQL server admin user
resource "random_password" "db_server_admin_password" {
  length           = 16
  special          = true
  override_special = "_%@"
}
