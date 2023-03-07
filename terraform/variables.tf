variable "resource_group_name" {
  type        = string
  description = "Resource group name of where all resources will be created"
  default     = "rg-azure-ai-demo"
}

variable "bootstrap_resource_group_name" {
  type        = string
  description = "Resource group name of where the bootstrap resources are located"
}

variable "location" {
  type        = string
  description = "Azure region"
  default     = "uksouth"
}

variable "tags" {
  type        = map(string)
  description = "Map of the tags to use for the resources that are deployed"
  default     = {}
}

variable "vmss_name" {
  type        = string
  description = "Name of the Virtual Machine Scale Set to use"
}

variable "vmss_vnet_name" {
  type        = string
  description = "Name of the bootstrap Vnet"
}

variable "acr_name" {
  type        = string
  description = "Azure Container Registry name"
  default     = "azureaidemo"
}

variable "acr_admin_enabled" {
  type    = bool
  default = false
}

variable "acr_identity_type" {
  type        = string
  description = "The type of Managed Identity which should be assigned to the Container Registry. Possible values are SystemAssigned, UserAssigned"
  default     = "SystemAssigned"
}

variable "acr_identity_ids" {
  type        = list(any)
  description = "A list of User Managed Identity ID's which should be assigned to the Container Registry"
  default     = null
}

variable "subnet_name_private_endpoint" {
  type        = string
  description = "Name of the private endpoint subnet"
}

variable "subnet_name_vnet_integration" {
  type        = string
  description = "Name of the vnet integration subnet"
}

variable "app_service_plan_name" {
  type        = string
  description = "Name of the app service plan"
  default     = "azureaidemoplan"
}

variable "app_service_name" {
  type        = string
  description = "Name of the app service plan"
  default     = "azureaidemo"
}

variable "application_name" {
  type        = string
  description = "Name of the private endpoint subnet"
  default     = "azureaidemo"
}

variable "cognitive_account_name" {
  type        = string
  description = "Azure Cognitive Services Account name"
  default     = "azureaidemo"
}

variable "cognitive_sku" {
  type        = string
  description = "Azure Cognitive Services SKU"
  default     = "S1"
}

variable "cognitive_kind" {
  type        = string
  description = "Azure Cognitive Services service"
  default     = "TextTranslation"
}

variable "cognitive_custom_subdomain" {
  type        = string
  description = "Azure Cognitive Services custom subdomain"
}

variable "cognitive_private_link" {
  type        = bool
  description = "Deploy Azure Cognitive Services as a private endpoint?"
  default     = false
}

variable "key_vault_name" {
  type        = string
  description = "Name of the Azure Key Vault"
  default     = "azureaidemo"
}

variable "openai_api_key" {
  type        = string
  description = "OpenAI API Key"
}
