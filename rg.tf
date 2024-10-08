#https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group
resource "azurerm_resource_group" "resource_group" {
  location = var.location
  name     = "${var.environment}-${var.project_name}-rg"
  tags     = var.tags
}