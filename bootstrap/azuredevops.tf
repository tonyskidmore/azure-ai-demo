resource "random_string" "build_index" {
  length      = 6
  min_numeric = 6
}

resource "azuredevops_project" "project" {
  name        = var.ado_project_name
  description = var.ado_project_description
  visibility  = var.ado_project_visibility
}

resource "azuredevops_git_repository" "repository" {
  for_each       = var.git_repos
  project_id     = azuredevops_project.project.id
  name           = each.value.name
  default_branch = each.value.default_branch
  initialization {
    init_type   = each.value.initialization.init_type
    source_type = each.value.initialization.source_type
    source_url  = each.value.initialization.source_url
  }
}

# error workaround possibilities
# https://stackoverflow.com/questions/70049758/terraform-for-each-one-by-one
# https://pet2cattle.com/2021/06/time-sleep-between-resources
resource "azuredevops_build_definition" "build_definition" {
  for_each = var.build_definitions

  project_id      = azuredevops_project.project.id
  name            = each.value.name
  path            = each.value.path
  agent_pool_name = var.ado_pool_name

  ci_trigger {
    use_yaml = true
  }

  repository {
    repo_type = "TfsGit"
    repo_id   = azuredevops_git_repository.repository[each.value.repo_ref].id
    # branch_name = "main"
    branch_name = each.value.branch_name
    yml_path    = each.value.yml_path
  }

  depends_on = [
    module.terraform-azurerm-vmss-devops-agent
  ]
}

# https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep

# add permissions to repo for pipeline
resource "null_resource" "build_definition_repo_perms" {
  for_each = azuredevops_build_definition.build_definition
  triggers = {
    id = each.value.id
  }

  depends_on = [
    azuredevops_build_definition.build_definition,
    azuredevops_git_repository.repository
  ]

  provisioner "local-exec" {
    command = <<EOF
id=${each.value.id}
payload="{ \"pipelines\": [{ \"id\": $id, \"authorized\": true }]}"
echo $id
echo $payload
curl \
  --silent \
  --show-error \
  --user ":$AZDO_PERSONAL_ACCESS_TOKEN" \
  --header "Content-Type: application/json" \
  --request PATCH \
  --data "$payload" \
  "$AZDO_ORG_SERVICE_URL/${var.ado_project_name}/_apis/pipelines/pipelinePermissions/repository/${azuredevops_project.project.id}.${azuredevops_git_repository.repository["repo2"].id}?api-version=7.0-preview.1" | jq .
EOF
  }
}


resource "azuredevops_environment" "demo" {
  project_id  = azuredevops_project.project.id
  name        = "demo"
  description = "Demo environment"
}

# add permissions to environment for pipeline
resource "null_resource" "build_definition_env_perms" {
  for_each = azuredevops_build_definition.build_definition
  triggers = {
    id = each.value.id
  }

  depends_on = [
    azuredevops_build_definition.build_definition,
    azuredevops_environment.demo
  ]

  provisioner "local-exec" {
    command = <<EOF
id=${each.value.id}
payload="{ \"pipelines\": [{ \"id\": $id, \"authorized\": true }]}"
echo $id
echo $payload
curl \
  --silent \
  --show-error \
  --user ":$AZDO_PERSONAL_ACCESS_TOKEN" \
  --header "Content-Type: application/json" \
  --request PATCH \
  --data "$payload" \
  "$AZDO_ORG_SERVICE_URL/${var.ado_project_name}/_apis/pipelines/pipelinePermissions/environment/${azuredevops_environment.demo.id}?api-version=7.1-preview.1" | jq .
EOF
  }
}

resource "azuredevops_serviceendpoint_azurerm" "sub" {
  project_id            = azuredevops_project.project.id
  service_endpoint_name = var.service_endpoint_name
  description           = "Managed by Terraform"
  credentials {
    serviceprincipalid  = var.serviceprincipalid
    serviceprincipalkey = var.serviceprincipalkey
  }
  azurerm_spn_tenantid      = var.azurerm_spn_tenantid
  azurerm_subscription_id   = var.azurerm_subscription_id
  azurerm_subscription_name = var.azurerm_subscription_name
}

resource "azuredevops_resource_authorization" "azurerm" {
  for_each      = azuredevops_build_definition.build_definition
  project_id    = azuredevops_project.project.id
  resource_id   = azuredevops_serviceendpoint_azurerm.sub.id
  definition_id = each.value.id
  authorized    = true
}


resource "azuredevops_variable_group" "vars" {
  project_id   = azuredevops_project.project.id
  name         = "build"
  description  = "Build variables"
  allow_access = true

  variable {
    name  = "build_index"
    value = random_string.build_index.result
  }

  variable {
    name  = "project"
    value = var.ado_project_name
  }

  variable {
    name  = "ado_org"
    value = var.ado_org
  }

  variable {
    name  = "resource_group"
    value = var.demo_resource_group_name
  }

  variable {
    name         = "ado_ext_pat"
    secret_value = var.ado_ext_pat
    is_secret    = true
  }

  variable {
    name         = "openai_api_key"
    secret_value = var.openai_api_key
    is_secret    = true
  }

  variable {
    name         = "serviceprincipalid"
    secret_value = var.serviceprincipalid
    is_secret    = true
  }

  variable {
    name         = "serviceprincipalkey"
    secret_value = var.serviceprincipalkey
    is_secret    = true
  }

  variable {
    name         = "azurerm_spn_tenantid"
    secret_value = var.azurerm_spn_tenantid
    is_secret    = true
  }

  variable {
    name         = "azurerm_subscription_id"
    secret_value = var.azurerm_subscription_id
    is_secret    = true
  }

  variable {
    name  = "state_resource_group_name"
    value = azurerm_resource_group.azure-ai-demo.name
  }

  variable {
    name  = "state_storage_account_name"
    value = azurerm_storage_account.azure-ai-demo.name
  }

  variable {
    name  = "state_container_name"
    value = azurerm_storage_container.tfstate.name
  }

}

module "terraform-azurerm-vmss-devops-agent" {
  source                   = "tonyskidmore/vmss-devops-agent/azurerm"
  version                  = "0.2.1"
  ado_org                  = var.ado_org
  ado_pool_name            = var.ado_pool_name
  ado_project              = azuredevops_project.project.name
  ado_project_only         = "True"
  ado_service_connection   = azuredevops_serviceendpoint_azurerm.sub.service_endpoint_name
  ado_pool_desired_idle    = var.ado_pool_desired_idle
  vmss_admin_password      = var.vmss_admin_password
  vmss_name                = var.vmss_name
  vmss_resource_group_name = azurerm_resource_group.azure-ai-demo.name
  vmss_subnet_id           = module.network.vnet_subnets[index(var.subnet_names, var.vmss_subnet)]
  vmss_custom_data_data    = local.vmss_custom_data_data
  vmss_identity_type       = "SystemAssigned"
}
