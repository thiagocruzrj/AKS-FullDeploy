provider "azurerm" {
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
  features {}
}

resource "random_integer" "random_int" {
  min = 100
  max = 999
}

resource "azurerm_resource_group" "acrrg" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    environment = "shared"
    project     = "azbgaks"
  }
}

resource "azurerm_role_assignment" "aksacrrole" {
  scope                = azurerm_container_registry.aksacr.id
  role_definition_name = "AcrPull"
  principal_id         = var.service_principal_objectid

  depends_on = [azurerm_container_registry.aksacr]
}

resource "azurerm_role_assignment" "azdoacrrole" {
  scope                = azurerm_container_registry.aksacr.id
  role_definition_name = "AcrPush"
  principal_id         = var.azdo_service_principal_objectid

  depends_on = [azurerm_container_registry.aksacr]
}

resource "azurerm_container_registry" "aksacr" {
  name                = "${var.dns_prefix}acr"
  resource_group_name = azurerm_resource_group.acrrg.name
  location            = azurerm_resource_group.acrrg.location
  sku                 = "Standard"
  admin_enabled       = true
}