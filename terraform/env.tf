resource "azurerm_resource_group" "aksrg" {
  name = "${var.resource_group_name}-${random_integer.random_int.result}"
  location = var.location

  tags = {
    environment = var.environment
    project = "azbgaks"
  }
}

resource "azurerm_virtual_network" "kubevnet" {
  name = "${var.dns_prefix}-${random_integer.random_int.result}-vnet"
  address_space = ["10.0.0.0/20"]
  location = azurerm_resource_group.aksrg.location
  resource_group_name = azurerm_container_registry.aksrg.name

  tags = {
    environment = var.environment
    project = "azbgaks"
  }
}

resource "azurerm_subnet" "gwnet" {
  name                      = "gw-1-subnet"
  resource_group_name       = azurerm_resource_group.aksrg.name
  address_prefix            = "10.0.1.0/24"
  virtual_network_name      = azurerm_virtual_network.kubevnet.name
}

resource "azurerm_subnet" "acinet" {
  name                      = "aci-2-subnet"
  resource_group_name       = azurerm_resource_group.aksrg.name
  address_prefix            = "10.0.2.0/24"
  virtual_network_name      = azurerm_virtual_network.kubevnet.name
}

resource "azurerm_subnet" "fwnet" {
  name                      = "AzureFirewallSubnet"
  resource_group_name       = azurerm_resource_group.aksrg.name
  address_prefix            = "10.0.6.0/24"
  virtual_network_name      = azurerm_virtual_network.kubevnet.name
}

resource "azurerm_subnet" "ingnet" {
  name                      = "ing-4-subnet"
  resource_group_name       = azurerm_resource_group.aksrg.name
  address_prefix            = "10.0.4.0/24"
  virtual_network_name      = azurerm_virtual_network.kubevnet.name
}

resource "azurerm_subnet" "aksnet" {
  name                      = "aks-5-subnet"
  resource_group_name       = azurerm_resource_group.aksrg.name
  address_prefix            = "10.0.5.0/24"
  virtual_network_name      = azurerm_virtual_network.kubevnet.name
}

resource "azurerm_public_ip" "appgw_ip" {
  name                = "${var.dns_prefix}-${random_integer.random_int.result}-appgwpip"
  resource_group_name = azurerm_resource_group.aksrg.name
  location            = azurerm_resource_group.aksrg.location
  allocation_method   = "Dynamic"
}

resource "azurerm_application_gateway" "appgw" {
  name                = "${var.dns_prefix}-${random_integer.random_int.result}-appgw"
  resource_group_name = azurerm_resource_group.aksrg.name
  location            = azurerm_resource_group.aksrg.location

  sku {
    name = "Standard_Small"
    tier = "Standard"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "my-gateway-ip-configuration"
    subnet_id = azurerm_subnet.gwnet.id
  }

  frontend_port {
    name = "frontend-port-name"
    port = 80
  }

  frontend_ip_configuration {
    name                 = "frontend-config-name"
    public_ip_address_id = azurerm_public_ip.appgw_ip.id
  }

  backend_address_pool {
    name = "backend-pool-name"
    fqdns = ["${azurerm_public_ip.nginx_ingress.ip_address}.xip.io", "${azurerm_public_ip.nginx_ingress-stage.ip_address}.xip.io"]
  }

  backend_http_settings {
    name                  = "http-setting-name"
    cookie_based_affinity = "Disabled"
    path                  = "/"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 1
    connection_draining {
      enabled = true
      drain_timeout_sec = 30
    }
  }

  probe {
    name                = "probe"
    protocol            = "http"
    path                = "/"
    host                = "${azurerm_public_ip.nginx_ingress.ip_address}.xip.io"
    interval            = "30"
    timeout             = "30"
    unhealthy_threshold = "3"
  }

  http_listener {
    name                           = "listener-name"
    frontend_ip_configuration_name = "frontend-config-name"
    frontend_port_name             = "frontend-port-name"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "routing-rule"
    rule_type                  = "Basic"
    http_listener_name         = "listener-name"
    backend_address_pool_name  = "backend-pool-name"
    backend_http_settings_name = "http-setting-name"
  }
}

resource "azurerm_application_insights" "aksainsights" {
  name                = "${var.dns_prefix}-${random_integer.random_int.result}-ai"
  application_type    = "Node.JS"
  location            = "West Europe"
  resource_group_name = azurerm_resource_group.aksrg.name

  tags = {
    environment = var.environment
    project     = "azbgaks"
  }
}

resource "azurerm_log_analytics_workspace" "akslogs" {
  name                = "${var.dns_prefix}-${random_integer.random_int.result}-lga"
  location            = azurerm_resource_group.aksrg.location
  resource_group_name = azurerm_resource_group.aksrg.name
  sku                 = "PerGB2018"

  tags = {
    environment = var.environment
    project     = "azbgaks"
  }
}

resource "azurerm_log_analytics_solution" "akslogs" {
  solution_name         = "ContainerInsights"
  location              = azurerm_resource_group.aksrg.location
  resource_group_name   = azurerm_resource_group.aksrg.name
  workspace_resource_id = azurerm_log_analytics_workspace.akslogs.id
  workspace_name        = azurerm_log_analytics_workspace.akslogs.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/ContainerInsights"
  }
}