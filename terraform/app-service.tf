resource "azurerm_service_plan" "application" {
  name                = var.app_service_plan_name
  resource_group_name = data.azurerm_resource_group.ai-demo.name
  location            = var.location

  sku_name = "S1"
  os_type  = "Linux"

  tags = var.tags
}

resource "azurerm_linux_web_app" "application" {
  name                = var.app_service_name
  resource_group_name = data.azurerm_resource_group.ai-demo.name
  location            = var.location
  service_plan_id     = azurerm_service_plan.application.id
  https_only          = true

  tags = var.tags

  site_config {
    application_stack {
      docker_image     = "${azurerm_container_registry.acr.name}.azurecr.io/${var.application_name}/${var.application_name}"
      docker_image_tag = "latest"
    }
    # linux_fx_version                        = "DOCKER|${var.acr_name}${var.application_name}/${var.application_name}:latest"
    container_registry_use_managed_identity = true
    always_on                               = true
    ftps_state                              = "FtpsOnly"
    vnet_route_all_enabled                  = true
    http2_enabled                           = true
    minimum_tls_version                     = "1.2"
  }

  identity {
    type = "SystemAssigned"
  }

  logs {
    application_logs {
        file_system_level = "Error"
    }

    http_logs {
        file_system {
            retention_in_days = 10
            retention_in_mb   = 35
        }
    }
  }

  app_settings = {
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"
    "DOCKER_REGISTRY_SERVER_URL"          = "https://${var.acr_name}.azurecr.io"
    # "DOCKER_REGISTRY_SERVER_USERNAME"     = azurerm_container_registry.acr.admin_username
    # "DOCKER_REGISTRY_SERVER_PASSWORD"     = azurerm_container_registry.acr.admin_password
    "WEBSITES_PORT" = "8501"
    # WEBSITE_PULL_IMAGE_OVER_VNET             = true

    # These are app specific environment variables
  }
}

# site_config {
#     linux_fx_version = "DOCKER|${local.acr_name}/${each.value}:latest"
#     acr_use_managed_identity_credentials = true
# }

# app_settings = {
#     DOCKER_REGISTRY_SERVER_URL = "https://${local.acr_name}.azurecr.io"
# }

# identity {
#     type = "SystemAssigned"
# } 


# data "azurerm_client_config" "current" {}

# resource "azurerm_key_vault_access_policy" "application" {
#   key_vault_id = var.vault_id
#   tenant_id    = data.azurerm_client_config.current.tenant_id
#   object_id    = azurerm_linux_web_app.application.identity[0].principal_id

#   secret_permissions = [
#     "Get",
#     "List"
#   ]
# }

resource "azurerm_app_service_virtual_network_swift_connection" "swift_connection" {
  app_service_id = azurerm_linux_web_app.application.id
  subnet_id      = data.azurerm_subnet.vnet_integration.id
}


