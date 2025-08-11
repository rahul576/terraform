terraform {
  required_version = ">= 1.6.0"

  required_providers {
    azurerm = {
        source = "hashicorp/azurerm"
        version = "~> 4.27.0"
    }
  }
}

provider "azurerm" {
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  features {}
}