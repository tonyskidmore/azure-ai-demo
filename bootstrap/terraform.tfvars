ado_pool_name = "vmss-bootstrap-pool"

build_definitions = {

  "pipeline1" = {
    name     = "azure-ai-demo-pipeline",
    path     = "\\azure-ai-demo",
    repo_ref = "repo2",
    yml_path = "azure-ai-demo/terraform.yml"
  }
}

git_repos = {
  "repo1" = {
    name           = "ai-demo-src",
    default_branch = "refs/heads/init",
    initialization = {
      init_type   = "Import",
      source_type = "Git",
      source_url  = "https://github.com/tonyskidmore/azure-ai-demo.git"
    }
  }
  "repo2" = {
    name           = "pipelines",
    default_branch = "refs/heads/init",
    initialization = {
      init_type   = "Import",
      source_type = "Git",
      source_url  = "https://github.com/tonyskidmore/azure-pipelines-yaml.git"
    }
  }
}

location            = "uksouth"
nsg_name            = "nsg-azure-ai-demo"
resource_group_name = "rg-azure-ai-demo-bootstrap"
vmss_name           = "vmss-azure-ai-demo-bootstrap"
vmss_admin_password = "Sup3rS3cr3tP@55w0rd!"
vmss_vnet_name      = "vnet-azure-ai-demo"
vnet_address_space  = ["192.168.0.0/16"]
subnet_names = [
  "snet-azure-ai-demo-ado-agents",
  "snet-azure-ai-demo-vnet-int",
  "snet-azure-ai-demo-private-endpoint"
]
subnet_prefixes = [
  "192.168.0.0/28",
  "192.168.0.16/28",
  "192.168.0.32/27"
]


# subnet_prefixes = [
#   "10.142.224.0/29",
#   "10.142.224.8/29",
#   "10.142.224.16/29",
#   "10.142.224.24/29",
#   "10.142.224.32/27",
#   "10.142.224.64/27"
# ]
# subnet_names = [
#   "snet-sra3pi-sercodotcom-solr-01",
#   "snet-sra3pi-sercodotcom-db-01",
#   "snet-sra3pi-sercodotcom-integration-01",
#   "snet-sra3pi-sercodotcom-endpoints-01",
#   "snet-sra3pi-publicservices-endpoints-01",
#   "snet-sra3pi-publicservices-aci-agents-01"
# ]
# subnet_service_endpoints = {
#   snet-sra3pi-publicservices-aci-agents-01 = ["Microsoft.Web"],
#   snet-sra3pi-publicservices-aci-agents-01 = ["Microsoft.Storage"]
# }
# subnet_delegations = [
#   {
#     subnet_name        = "snet-sra3pi-sercodotcom-integration-01"
#     name               = "Microsoft.Web.serverFarms"
#     delegation_name    = "Microsoft.Web/serverFarms"
#     delegation_actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
#   },
#   {
#     subnet_name        = "snet-sra3pi-publicservices-aci-agents-01"
#     name               = "Microsoft.ContainerInstance.containerGroups"
#     delegation_name    = "Microsoft.ContainerInstance/containerGroups"
#     delegation_actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
#   }
# ]
# nsg_names = [
#   "nsg-sra3pi-sercodotcom-solr-01",
#   "nsg-sra3pi-sercodotcom-db-01",
#   "nsg-sra3pi-sercodotcom-integration-01",
#   "nsg-sra3pi-sercodotcom-endpoints-01",
#   "nsg-sra3pi-publicservices-endpoints-01",
#   "nsg-sra3pi-publicservices-aci-agents-01"
#   ]
