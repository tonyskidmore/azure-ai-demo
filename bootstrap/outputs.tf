output "storage_account_name" {
  value       = azurerm_storage_account.azure-ai-demo.name
  description = "Azure storage account name"
}

output "container_name" {
  value       = azurerm_storage_container.tfstate.name
  description = "Azure storage container name"
}

output "key" {
  value       = "000-bootstrap.tfstate"
  description = "Azure storage blob name"
}

output "resource_group_name" {
  value       = azurerm_resource_group.azure-ai-demo.name
  description = "Azure storage resource group name"
}

output "git_repo_id" {
  value       = azuredevops_git_repository.repository["repo1"].id
  description = "Azure storage resource group name"
}

output "ado_project_name" {
  value       = var.ado_project_name
  description = "Azure DevOps project"
}

output "terraform_pipeline" {
  value = azuredevops_build_definition.build_definition["pipeline1"].id
}
