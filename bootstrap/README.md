# Azure DevOps Demo Environment

This creates an Azure DevOps project that can be used to run Pipelines to create the Azure AI demo environment.
By default the project will be called `azure-ai-demo`.  It will create the following items in the project:

| Item                       | Description                                                                                          |
|----------------------------|------------------------------------------------------------------------------------------------------|
| AzureRM Service Connection | Service connection that will be used as the connection for Azure Scale Set agents                    |
| Repos                      | Azure Repos created to import this module and an associated Azure Pipelines repository from GitHub   |
| Pipelines                  | Pipelines will be created and given the necessary permissions to the required Azure DevOps resources |
| Environment                | A Pipelines environment will be created and is referenced by the YAML Pipelines                      |
| Variable group             | A variable group is created to store the variables and secrets required for Pipeline execution       |

_Note:_
The demo environment uses Azure Repos but that is only to make things easier for creating the demos, it is not a prerequisite to using the module.
The Azure DevOps YAML pipelines using in the demo environment are located in a separate repo: [azure-pipelines-yaml](https://github.com/tonyskidmore/azure-pipelines-yaml).

Azure resources are also create:

| Item                   | Default                       | Description                                                                                          |
|------------------------|-------------------------------|------------------------------------------------------------------------------------------------------|
| Resource group         | rg-azure-ai-demo-bootstrap    | Service connection that will be used as the connection for Azure Scale Set agents                    |
| Network security group | TBD                           | A default Network security                                                                           |
| Storage account        | sademoai{000000}              | Storage account for Terraform state named sademovmss + 6 numeric digits                              |
| Virtual network        | vnet-azure-ai-demo            | Virtual network with an address space of 192.168.0.0/16                                              |
| Subnets                | multiple                      | Subnets for ADO VMSS agents, app service vnet integration and private endpoints                      |

_Note:_
All resources are deployed into the single resource group to keep things contained and easier to destroy.

## Requirements

The requirements defined in the main README of this repository plus the below:

### Azure
Running the bootstrap Terraform code:  

User with Subscription level access of:
Contributor + User Access Administrator
OR
Owner

Service principal created with:
````bash

az ad sp create-for-rbac --name azure-ai-demo \
                         --role reader \
                         --scopes /subscriptions/00000000-0000-0000-0000-000000000000

````

### Azure DevOps
Personal Access Token - Full Access


## Environment variables

Certain environment variables need to be defined prior to creating the demo environment.


````bash

# values from the above created service principal - replace values with your tenant, subscription and service principal values
# set the values containing secrets and values
 export AZ_SUBSCRIPTION_ID=00000000-0000-0000-0000-000000000000
 export AZ_TENANT_ID=00000000-0000-0000-0000-000000000000
 export AZ_CLIENT_ID=00000000-0000-0000-0000-000000000000
 export AZ_CLIENT_SECRET=<secret-here>
 export OPENAI_API_KEY=<key-here>

 export AZDO_PERSONAL_ACCESS_TOKEN="your PAT here" # full access
export AZDO_ORG_SERVICE_URL="https://dev.azure.com/tonyskidmore" # your organization

# reference the above to pass into Terraform
export TF_VAR_ado_org="$AZDO_ORG_SERVICE_URL"
export TF_VAR_ado_ext_pat="$AZDO_PERSONAL_ACCESS_TOKEN"
export TF_VAR_serviceprincipalid="$AZ_CLIENT_ID"
export TF_VAR_serviceprincipalkey="$AZ_CLIENT_SECRET"
export TF_VAR_azurerm_spn_tenantid="$AZ_TENANT_ID"
export TF_VAR_azurerm_subscription_id="$AZ_SUBSCRIPTION_ID"
export TF_VAR_openai_api_key="$OPENAI_API_KEY"

git clone https://github.com/tonyskidmore/azure-ai-demo.git
cd bootstrap
az login # if not login with user permissions as mentioned above
terraform init
terraform plan -out tfplan
terraform apply tfplan

````
_Note:_
The Azure DevOps Terraform provider occasionally throws up `Internal Error Occurred` errors.
If it does just re-run the `plan` and `apply` steps and it should go through OK.

Open Azure DevOps and explore the `azure-ai-demo` project.  Review the Pipelines.

To destroy the demo environment, first run the **terraform** pipeline and choose the destroy option to delete the contents of the demo resource group.
Then from the location that the bootstrap code was run from:

````bash

terraform plan -destroy -out tfplan
terraform apply tfplan

````

If you find yourself in a position that things have not destroyed correctly you can take manual steps to tidy up:

* In Azure DevOps delete the `azure-ai-demo` project
* In Azure DevOps at the Organization level remove the `vmss-bootstrap-pool` agent pool.
* In Azure delete the `rg-azure-ai-demo` and `rg-azure-ai-demo-bootstrap` resource groups.
* Locally from the `bootstrap` directory remove `terraform.tfstate*`
