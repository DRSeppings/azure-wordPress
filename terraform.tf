terraform {
    backend "azurerm" {
    resource_group_name  =  var.backend_rg_name 
    storage_account_name  = var.backend_storage_account_name 
    container_name        = var.backend_container_name 
    key                   = var.backend_key 
  }

  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.99.0"

    }
  }
}
