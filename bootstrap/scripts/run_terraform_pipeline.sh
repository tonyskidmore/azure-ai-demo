#!/bin/bash

create_post_data()
{
  cat <<EOF
{
    "resources": {
        "repositories": {
            "self": {
                "refName": "refs/heads/main"
            }
        }
    },
    "variables": {
        "HELLO_WORLD": {
            "isSecret": false,
            "value": "HelloWorldValue"
        }
    }
}
EOF
}

data="$(create_post_data)"

# POST https://dev.azure.com/{organization}/{project}/_apis/pipelines/{pipelineId}/runs?api-version=7.0
export PROJECT=$(terraform output -raw ado_project_name)
export PIPELINE_ID=$(terraform output -raw terraform_pipeline)
printf "AZDO_ORG_SERVICE_URL: %s\n" "$AZDO_ORG_SERVICE_URL"
printf "AZDO_PERSONAL_ACCESS_TOKEN: %s\n" "$AZDO_PERSONAL_ACCESS_TOKEN"
printf "PROJECT: %s\n" "$PROJECT"
printf "PIPELINE_ID: %s\n" "$PIPELINE_ID"
printf "%s/%s/_apis/pipelines/%s/runs?api-version=7.0\n" "$AZDO_ORG_SERVICE_URL" "$project" "$pipeline_id"
echo "$data"