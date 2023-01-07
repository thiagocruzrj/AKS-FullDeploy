resource "azurerm_key_vault" "aksvault" {
  name                        = "${var.dns_prefix}-${random_integer.random_int.result}-vault"
  location                    = azurerm_resource_group.aksrg.location
  resource_group_name         = azurerm_resource_group.aksrg.name
  enabled_for_disk_encryption = false
  tenant_id = var.tenant_id

  sku_name = "standard"

  tags = {
    environment = var.environment
    project     = "azbgaks"
  }
}

resource "azurerm_key_vault_access_policy" "aksvault_policy_app" {
  key_vault_id = azurerm_key_vault.aksvault.id

  tenant_id = var.tenant_id
  object_id = var.azdo_service_principal_objectid

  secret_permissions = [ "get" ]
}

resource "azurerm_key_vault_access_policy" "aksvault_policy_forme" {
  key_vault_id = azurerm_key_vault.aksvault.id

  tenant_id = var.tenant_id
  object_id = var.object_id

  secret_permissions = [
      "get",
      "list",
      "set"
  ]
}

resource "azurerm_key_vault_secret" "appinsights_secret" {
  name         = "appinsights-key"
  value        = azurerm_application_insights.aksainsights.instrumentation_key
  key_vault_id = azurerm_key_vault.aksvault.id
  
  tags = {
    environment = var.environment
    project     = "azbgaks"
  }
}

resource "azurerm_key_vault_secret" "redis_host_secret" {
  name         = "redis-host"
  value        = azurerm_redis_cache.aksredis.hostname
  key_vault_id = azurerm_key_vault.aksvault.id
  
  tags = {
    environment = var.environment
    project     = "azbgaks"
  }
}

resource "azurerm_key_vault_secret" "redis_access_secret" {
  name         = "redis-access"
  value        = azurerm_redis_cache.aksredis.primary_access_key
  key_vault_id = azurerm_key_vault.aksvault.id
  
  tags = {
    environment = var.environment
    project     = "azbgaks"
  }
}

resource "azurerm_key_vault_secret" "acrname_secret" {
  name         = "acr-name"
  value        = azurerm_container_registry.aksacr.name
  key_vault_id = azurerm_key_vault.aksvault.id
  
  tags = {
    environment = var.environment
    project     = "azbgaks"
  }
}

resource "azurerm_key_vault_secret" "public_ip" {
  name         = "azbgaks-fqdn"
  value        = "${azurerm_public_ip.nginx_ingress.ip_address}.xip.io"
  key_vault_id = azurerm_key_vault.aksvault.id
  
  tags = {
    environment = var.environment
    project     = "azbgaks"
  }
}

resource "azurerm_key_vault_secret" "public_ip_stage" {
  name         = "azbgaks-fqdn-stage"
  value        = "${azurerm_public_ip.nginx_ingress-stage.ip_address}.xip.io"
  key_vault_id = azurerm_key_vault.aksvault.id
  
  tags = {
    environment = var.environment
    project     = "azbgaks"
  }
}

resource "azurerm_key_vault_secret" "phoenix-namespace" {
  name         = "azbgaks-namespace"
  value        = "calculator"
  key_vault_id = azurerm_key_vault.aksvault.id
  
  tags = {
    environment = var.environment
    project     = "azbgaks"
  }
}

resource "azurerm_key_vault_secret" "aks-name" {
  name         = "aks-name"
  value        = azurerm_kubernetes_cluster.akstf.name
  key_vault_id = azurerm_key_vault.aksvault.id
  
  tags = {
    environment = var.environment
    project     = "azbgaks"
  }
}

resource "azurerm_key_vault_secret" "aks-group" {
  name         = "aks-group"
  value        = azurerm_resource_group.aksrg.name
  key_vault_id = azurerm_key_vault.aksvault.id
  
  tags = {
    environment = var.environment
    project     = "azbgaks"
  }
}