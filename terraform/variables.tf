variable "resource_group_name" {
  type        = string
  description = "Resource group name of where all resources will be created"
  default     = "rg-azure-ai-demo"
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
