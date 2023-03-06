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

# data="$(create_post_data)"
data="{}"

# POST https://dev.azure.com/{organization}/{project}/_apis/pipelines/{pipelineId}/runs?api-version=7.0
PROJECT=$(terraform output -raw ado_project_name)
PIPELINE_ID=$(terraform output -raw terraform_pipeline)
printf "AZDO_ORG_SERVICE_URL: %s\n" "$AZDO_ORG_SERVICE_URL"
printf "PROJECT: %s\n" "$PROJECT"
printf "PIPELINE_ID: %s\n" "$PIPELINE_ID"
url="${AZDO_ORG_SERVICE_URL}/${PROJECT}/_apis/pipelines/${PIPELINE_ID}/runs?api-version=7.0\n"
printf "%s\n" "$url"
echo "$data"

curl \
--silent \
--show-error \
--retry 10 \
--retry-delay 3 \
--retry-max-time 120 \
--max-time 120 \
--connect-timeout 20 \
--header "Content-Type: application/json" \
--request POST \
--data "$data" \
--user ":$AZDO_PERSONAL_ACCESS_TOKEN" "$url"
