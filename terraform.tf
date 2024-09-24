terraform {
    backend "azurerm" {
    resource_group_name  = "tf-backend-rg"       # The existing resource group where the storage account is located
    storage_account_name  = "drtfbkend"           # The existing storage account name
    container_name        = "terraform"            # The name of the existing blob container
    key                   = "terraform.tfstate"    # The name of the state file
  }

  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.99.0"

    }
  }
}
