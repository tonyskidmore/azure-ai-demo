#!/bin/bash


# TODO: set to "refs/heads/main"
create_post_data()
{
  cat <<EOF
{
    "resources": {
        "repositories": {
            "ai-demo-src": {
                "refName": "refs/heads/pipelines"
            }
        }
    }
}
EOF
}

# set depending on requirements
data="$(create_post_data)"
# data="{}"

# POST https://dev.azure.com/{organization}/{project}/_apis/pipelines/{pipelineId}/runs?api-version=7.0
PROJECT=$(terraform output -raw ado_project_name)
PIPELINE_ID=$(terraform output -raw terraform_pipeline)
printf "AZDO_ORG_SERVICE_URL: %s\n" "$AZDO_ORG_SERVICE_URL"
printf "PROJECT: %s\n" "$PROJECT"
printf "PIPELINE_ID: %s\n" "$PIPELINE_ID"
url="${AZDO_ORG_SERVICE_URL}/${PROJECT}/_apis/pipelines/${PIPELINE_ID}/runs?api-version=7.0"
printf "%s\n" "$url"
# echo "$data"

response=$(curl \
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
--user ":$AZDO_PERSONAL_ACCESS_TOKEN" "$url")

echo "$response"
state=$(echo "$response" | grep -oP '(?<="state":")(.+)(?=","createdDate)')
printf "pipeline state: %s\n" "$state"
