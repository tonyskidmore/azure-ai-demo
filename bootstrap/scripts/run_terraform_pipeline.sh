#!/bin/bash

# export BRANCH_NAME to the desired feature branch if needed
BRANCH_NAME="${BRANCH_NAME:-refs/heads/main}"
# or get current branch
BRANCH_NAME=$(git rev-parse --symbolic-full-name HEAD
printf "BRANCH_NAME: %s\n" "$BRANCH_NAME"

create_post_data()
{
  cat <<EOF
{
    "resources": {
        "repositories": {
            "ai-demo-src": {
                "self":{"refName":"refs/heads/pipelines"}
            }
        }
    }
}
EOF
}

# define data depending on whether we are using the main or featrure branch
if [[ "$BRANCH_NAME" == "refs/heads/main" ]]
then
  data="{}"
else
  data="$(create_post_data)"
fi


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
