terraform {
  required_version = "1.4.6"
#   backend "azurerm" {}
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.31.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.0.1"
    }
  }
}

provider "azurerm" {
  features {}
}
