variable "subscription_id" {
    type = string
    default = "4b6c3a4c-82d9-4e88-956e-f032ff864b55"
    description = "Dev subscrition value"
  
}

variable "client_id" {
    type = string
    default = "7dc606e0-56b4-4a11-ae15-cac353e60d44"
    description = "client id"
  
}

variable "client_secret" {
    type = string
    default = "4Tu7Q~4-w2Z3pqoVRx46TJAG3UWqLioJuB488"
    description = "client secret"
  
}

variable "tenant_id" {
    type = string
    default = "78cf26f3-17af-4b8e-bcc4-30bd7c2390f4"
    description = "tenant id"
  
}

terraform {
  backend "azurerm" {
      resource_group_name = "terraformstate-rg"
      storage_account_name = "terraformprodapac111"
      container_name = "cicd"
      key = "terraform.cicd"
      access_key = "PT5DthH3PvUSDk4ITeqTD/ZZpveXNiMjPiCjfaQWS8WqoUvJ04i889hw8bgZL09OYnq0vvSv7uwN+AStGKGYog=="
  }
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.97.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}

  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
}


resource "azurerm_resource_group" "testrglabel" {
  name = "testrgeastus"
  location = "East Us"
  tags = {
    "name" = "${local.setup_name}-rsg"
  }
  
}

resource "azurerm_app_service_plan" "testappaplan" {
  name = "testappplan"
  location = azurerm_resource_group.testrglabel.location
  resource_group_name = azurerm_resource_group.testrglabel.name
  sku {
    tier = "standard"
    size = "S1"
  }
  depends_on = [
    azurerm_resource_group.testrglabel
  ]
  tags = {
    "name" = "${local.setup_name}-appplan"
  }
}

locals {
  setup_name = "practice-hyd"
}

resource "azurerm_app_service" "testwebapp" {
  name = "testwebapp1895"
  location = azurerm_resource_group.testrglabel.location
  resource_group_name = azurerm_resource_group.testrglabel.name
  app_service_plan_id = azurerm_app_service_plan.testappaplan.id
  tags = {
    "name" = "${local.setup_name}-webapp"
  }
  depends_on = [
    azurerm_app_service_plan.testappaplan
  ]
  
}
