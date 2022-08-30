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
az deployment group create --name Step01Spoke --resource-group $corerg --template-file ./steps/01-vnet/amlspoke.bicep
```

```
az deployment group create --name Step01VNetPeering --resource-group $corerg --template-file ./steps/01-vnet/hubtospokepeering.bicep
az deployment group create --name Step01VNetPeering --resource-group $corerg --template-file ./steps/01-vnet/spoketohubpeering.bicep
```

# Create Azure Firewall
```
az deployment group create --name Step01 --resource-group $corerg --template-file ./steps/01-vnet/firewall.bicep
```

# Create Azure Custom DNS VM
```
az deployment group create --name Step02 --resource-group $corerg --template-file .\steps\02-firewall\customdns.bicep --parameters adminUsername="amlholadmin02" --parameters adminUserPassword="amlH0!mJhBy3"
```

# Create VPN / Bastion / Jumpbox

```
az deployment group create --name Step03Jumpbox --resource-group $amlrg --template-file .\steps\03-aml\jumpbox.bicep --parameters adminUsername="amljumpboxadmin01" --parameters adminUserPassword="amlH0!mJhBy3"
```

# Create Workspace Resources

# Create Firewall Rules

# Create Route Table

# Create AML Workspace

