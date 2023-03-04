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

location                     = "uksouth"
nsg_name                     = "nsg-azure-ai-demo"
resource_group_name          = "rg-azure-ai-demo-bootstrap"
vmss_name                    = "vmss-azure-ai-demo-bootstrap"
vmss_admin_password          = "Sup3rS3cr3tP@55w0rd!"
vmss_vnet_name               = "vnet-azure-ai-demo"
vmss_vnet_address_space      = ["192.168.0.0/16"]
vmss_subnet_name             = "snet-azure-ai-demo-ado-agent"
vmss_subnet_address_prefixes = ["192.168.0.0/24"]
