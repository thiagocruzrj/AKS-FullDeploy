#!/usr/bin/env bash
set -o pipefail

DEPLOYMENT_NAME="$1"
LOCATION="$2"

if ["$DEPLOYMENT_NAME" == ""]; then
echo "No team_name provided - aborting"
exit 0;
fi

if [[ $DEPLOYMENT_NAME =~ ^[a-z0-9]{3,6}$ ]]; then
    echo "Deployment $DEPLOYMENT_NAME name is valid"
else
    echo "Deployment $DEPLOYMENT_NAME name is invalid - only numbers and lower case min 3 and max 6 chars allowed - aborting"
    exit 0;
fi

if ["$LOCATION" == ""]; then
LOCATION="northeurope"
echo "No location provided - defaulting to $LOCATION"
fi

if ["$AZURE_CREDENTIALS" == ""]; then
    echo "no azure credentials found"
    exit 0;
else
    TENANT_ID=$(echo "$AZURE_CREDENTIALS" | jq -r ".tenantId")
    CLIENT_ID=$(echo "$AZURE_CREDENTIALS" | jq -r ".clientID")
    ARM_CLIENT_SECRET=$(echo "$AZURE_CREDENTIALS" | jq -r ".clientSecret")
    SUBSCRIPTION_ID=$(echo "$AZURE_CREDENTIALS" | jq -r ".subscriptionID")

    echo "found the following azure credentials"
    echo "tenantID: $TENANT_ID"
    echo "subscriptionID: $SUBSCRIPTION_ID"
    echo "clientID: $CLIENT_ID"
fi