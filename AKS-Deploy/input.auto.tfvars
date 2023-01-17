aks_vnet_name = "aksvnet"

sshkvsecret = "akssshpubkey"

clientidkvsecret = "spn-id"

spnkvsecret = "spn-secret"

vnetcidr = ["10.0.0.0/24"]

subnetcidr = ["10.0.0.0/25"]

keyvault_rg = "aks-rg"

keyvault_name = "akscluster-kv"

azure_region = "eastus"

resource_group = "akscluster-rg"

cluster_name = "akscluster"

dns_name = "akscluster"

admin_username = "aksuser"

kubernetes_version = "1.24.6"

agent_pools = {
      name            = "pool1"
      count           = 2
      vm_size         = "Standard_D2_v2"
      os_disk_size_gb = "30"
    }
