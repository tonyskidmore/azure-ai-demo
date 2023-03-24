resource "azurerm_service_plan" "application" {
  name                = var.app_service_plan_name
  resource_group_name = data.azurerm_resource_group.ai-demo.name
  location            = var.location

  sku_name = "S1"
  os_type  = "Linux"

  tags = var.tags
}

resource "azurerm_linux_web_app" "application" {
  name                = "${var.app_service_name}${random_string.build_index.result}"
  resource_group_name = data.azurerm_resource_group.ai-demo.name
  location            = var.location
  service_plan_id     = azurerm_service_plan.application.id
  https_only          = true

  tags = var.tags

  site_config {
    application_stack {
      docker_image     = "${azurerm_container_registry.acr.name}.azurecr.io/${var.app_service_name}${random_string.build_index.result}/${var.app_service_name}${random_string.build_index.result}"
      docker_image_tag = "latest"
    }
    container_registry_use_managed_identity = true
    always_on                               = true
    vnet_route_all_enabled                  = true
    ftps_state                              = "FtpsOnly"
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
    WEBSITES_ENABLE_APP_SERVICE_STORAGE = "false"
    # DOCKER_REGISTRY_SERVER_URL          = "https://${var.acr_name}.azurecr.io"
    WEBSITES_PORT      = "8501"
    OPENAI_API_KEY     = "@Microsoft.KeyVault(VaultName=${azurerm_key_vault.application.name};SecretName=openai-api-key)"
    COG_SERVICE_KEY    = "@Microsoft.KeyVault(VaultName=${azurerm_key_vault.application.name};SecretName=cog-service-key)"
    COG_SERVICE_REGION = var.location
    # https://learn.microsoft.com/en-us/azure/cognitive-services/cognitive-services-virtual-networks
    COG_SERVICE_ENDPOINT = "https://api.cognitive.microsofttranslator.com"
    # https://github.com/hashicorp/terraform-provider-azurerm/issues/19096
    WEBSITE_PULL_IMAGE_OVER_VNET = true
  }

  lifecycle {
    ignore_changes = [
      # https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_web_app#virtual_network_subnet_id
      virtual_network_subnet_id,
      site_config.application_stack
    ]
  }
}

resource "azurerm_app_service_virtual_network_swift_connection" "swift_connection" {
  app_service_id = azurerm_linux_web_app.application.id
  subnet_id      = data.azurerm_subnet.vnet_integration.id
}
