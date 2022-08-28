# Create Resource Groups

```
$corerg="amlholcore-dev-rg"
$amlrg="amlholws-dev-rg"

az group create --location eastus --name $corerg
az group create --location eastus --name $amlrg
```

# Create Virtual Networks and Subnetd
```
az deployment group create --name Step01 --resource-group $corerg --template-file ./steps/01-vnet/hub.bicep
```

# Create Azure Firewall
```
az deployment group create --name Step01 --resource-group $corerg --template-file ./steps/01-vnet/firewall.bicep
```
# Create VPN / Bastion / Jumpbox

# Create Workspace Resources

# Create Firewall Rules

# Create Route Table

# Create AML Workspace

