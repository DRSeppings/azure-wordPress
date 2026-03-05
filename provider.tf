#https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs
# Authentication is handled via ARM_* environment variables (service principal)
# or Azure CLI for local development. Do not hardcode auth flags here.
provider "azurerm" {
  features {}
}
