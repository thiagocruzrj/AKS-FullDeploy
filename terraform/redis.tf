resource "azurerm_redis_cache" "aksredis" {
  name                = "${var.dns_prefix}-${random_integer.random_int.result}-redis"
  location            = azurerm_resource_group.aksrg.location
  resource_group_name = azurerm_resource_group.aksrg.name
  capacity            = 0
  family              = "C"
  sku_name            = "Basic"
  enable_non_ssl_port = true
  redis_configuration {
  }

  tags = {
    environment = var.environment
    project     = "azbgaks"
  }
}