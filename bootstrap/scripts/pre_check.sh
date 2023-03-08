#!/bin/bash

required_variables=("AZ_SUBSCRIPTION_ID" "AZ_TENANT_ID" "AZ_CLIENT_ID"
"AZ_CLIENT_SECRET" "AZDO_PERSONAL_ACCESS_TOKEN" "AZDO_ORG_SERVICE_URL" "TF_VAR_ado_org"
"TF_VAR_ado_ext_pat" "TF_VAR_serviceprincipalid" "TF_VAR_serviceprincipalkey" "TF_VAR_azurerm_spn_tenantid"
"TF_VAR_azurerm_subscription_id")

for i in "${required_variables[@]}"
do
    if [[ ! "${i,,}" =~ (token)|(key)|(secret)|(pat) ]]
    then
      printf "%s: %s\n" "$i" "${!i}"
    else
      printf "%s: <redacted>\n" "$i"
    fi
    if [[ -z "${!i}" ]]
    then
      echo "Value for $i cannot be empty"
      exit 1
    fi
done
