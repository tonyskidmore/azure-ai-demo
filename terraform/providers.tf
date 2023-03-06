terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.1.0"
    }
    random = {
      source  = "registry.terraform.io/hashicorp/random"
      version = ">=3.4.0"
    }
  }
  required_version = ">= 1.0.0"
  # backend "azurerm" {}
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }
}
