#https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs
provider "azurerm" {
  features {
  }
  environment                = "public"
  use_msi                    = false
  use_cli                    = true
  use_oidc                   = false
}
