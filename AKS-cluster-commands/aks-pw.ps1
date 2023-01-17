# Azure Login
Connect-AzAccount

# Create Resource Group
New-AzResourceGroup -Name "rgf-aks-pwsh" -Location "East US"

# Createint AKS
New-AzAksCluster -ResourceGroup "rgf-aks-pwsh" -Name "aks-powershell" -NodeCount 1

# Listing AKS clusters
Get-AzAksCluster

# Intalling Kubeclt
Install-AzAksKubectl

# Import credentials
Import-AzAksCredential -ResourceGroup "rgf-aks-pwsh" -Name "aks-powershell"

# List all nodes
kubectl get nodes

# Excluding AKS
Remove-AzAksCluster -ResourceGroup "rgf-aks-pwsh" -Name "aks-powershell"