DEPLOYMENT_NAME=dzphix1
echo "Creating service principals in azure"
AKS_SERVICE_PRINCIPAL_ID=$(az ad sp create-for-rbac --name $DEPLOYMENT_NAME-aks -o json | jq -r '.appId')
AZDO_SERVICE_PRINCIPAL_ID=$(az ad sp create-for-rbac --name $DEPLOYMENT_NAME-azdo -o json | jq -r '.appId')

AKS_SERVICE_PRINCIPAL_SECRET=$(az ad app credential reset --id $AKS_SERVICE_PRINCIPAL_ID -o json | jq '.password' -r)
AZDO_SERVICE_PRINCIPAL_SECRET=$(az ad app credential reset --id $AZDO_SERVICE_PRINCIPAL_ID -o json | jq '.password' -r)

AKS_SERVICE_PRINCIPAL_OBJECTID=$(az ad sp show --id $AKS_SERVICE_PRINCIPAL_ID -o json | jq '.id' -r)
AZDO_SERVICE_PRINCIPAL_OBJECTID=$(az ad sp show --id $AZDO_SERVICE_PRINCIPAL_ID -o json | jq '.objectId' -r)

AZURE_TENANT_ID=$(az account show --query tenantId -o tsv)
AZURE_SUBSCRIPTION_NAME=$(az account show --query name -o tsv)
AZURE_SUBSCRIPTION_ID=$(az account show --query id -o tsv)
AZURE_MYOWN_OBJECT_ID=$(az ad signed-in-user show --query id --output tsv)

echo -e "\n\n Remember these outputs:"
echo -e "Your Kubernetes service_principal_id should be \e[7m$AKS_SERVICE_PRINCIPAL_ID\e[0m"
echo -e "Your Kubernetes service_principal_secret should be \e[7m$AKS_SERVICE_PRINCIPAL_SECRET\e[0m"
echo -e "Your Azure DevOps service_principal_id should be \e[7m$AZDO_SERVICE_PRINCIPAL_ID\e[0m"
echo -e "Your Azure DevOps service_principal_secret should be \e[7m$AZDO_SERVICE_PRINCIPAL_SECRET\e[0m"
echo -e "Your Azure tenant_id should be \e[7m$AZURE_TENANT_ID\e[0m"
echo -e "Your Azure subscription_id should be \e[7m$AZURE_SUBSCRIPTION_ID\e[0m"
echo -e "Your Azure subscription_name should be \e[7m$AZURE_SUBSCRIPTION_NAME\e[0m"
echo -e "Your Azure DevOps Service Connection name should be \e[7mdefaultAzure\e[0m"
echo -e "\n\n"


echo -e "\n This is the private output in case you want to set them later:"
echo -e "DEPLOYMENT_NAME=$DEPLOYMENT_NAME"
echo -e "AKS_SERVICE_PRINCIPAL_ID=$AKS_SERVICE_PRINCIPAL_ID"
echo -e "AZDO_SERVICE_PRINCIPAL_ID=$AZDO_SERVICE_PRINCIPAL_ID"
echo -e "AKS_SERVICE_PRINCIPAL_SECRET=$AKS_SERVICE_PRINCIPAL_SECRET"
echo -e "AZDO_SERVICE_PRINCIPAL_SECRET=$AZDO_SERVICE_PRINCIPAL_SECRET"
echo -e "AKS_SERVICE_PRINCIPAL_OBJECTID=$AKS_SERVICE_PRINCIPAL_OBJECTID"
echo -e "AZDO_SERVICE_PRINCIPAL_OBJECTID=$AZDO_SERVICE_PRINCIPAL_OBJECTID"
echo -e "AZURE_TENANT_ID=$AZURE_TENANT_ID"
echo -e "AZURE_SUBSCRIPTION_NAME=$AZURE_SUBSCRIPTION_NAME"
echo -e "AZURE_SUBSCRIPTION_ID=$AZURE_SUBSCRIPTION_ID"
echo -e "AZURE_MYOWN_OBJECT_ID=$AZURE_MYOWN_OBJECT_ID"
echo -e "\n"