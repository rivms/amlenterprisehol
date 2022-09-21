# Pre-Requisites
- Install the Azure CLI tool or make use of cloud shell
- Clone the repo
- Start a PowerShell session or Cloud Shell (PowerShell) and switch directory to the ```setup``` folder and run the commands shown below from a Powershell terminal. 

# Infrastructure Deployment

## Create Resource Groups

```
$corerg="amlholhub-dev-rg"    # To be used for the creation of the hub virtual network and resources
$amlrg="amlwsholspoke-dev-rg" # To be used for the creation of the AML spoke virtual network and resources

az group create --location eastus --name $corerg
az group create --location eastus --name $amlrg
```

## Create Virtual Networks
```
az deployment group create --name Step01Hub --resource-group $corerg --template-file ./steps/01-vnet/hub.bicep
az deployment group create --name Step01Spoke --resource-group $corerg --template-file ./steps/01-vnet/amlspoke.bicep
```

```
az deployment group create --name Step01VNetPeeringHub --resource-group $corerg --template-file ./steps/01-vnet/hubtospokepeering.bicep
az deployment group create --name Step01VNetPeeringSpoke --resource-group $corerg --template-file ./steps/01-vnet/spoketohubpeering.bicep
```

# Create private zones

az deployment group create --name Step01PrivateDnsZone --resource-group $corerg --template-file ./steps/01-vnet/privatednszones.bicep 

# Deploy Bastion

```
az deployment group create --name Step01Bastion --resource-group $corerg --template-file ./steps/01-vnet/bastion.bicep
```

# Create Azure Firewall
```
az deployment group create --name Step02Firewall --resource-group $corerg --template-file ./steps/02-firewall/firewall.bicep
```

# Set Firewall Application Rules

```
az deployment group create --name Step02FirewallRules --resource-group $corerg --template-file ./steps/02-firewall/firewallrules.bicep
```

# Create Azure Custom DNS VM
```
az deployment group create --name Step02CustomDns --resource-group $corerg --template-file .\steps\02-firewall\customdns.bicep --parameters adminUsername="amlholadmin02" --parameters adminUserPassword="amlH0!mJhBy3"
```

# Configure DNS Forwarder
Using Bastion connect to the DNS VM. Download the PowerShell script ```https://amlholst001.blob.core.windows.net/amlhol/dns.ps1?sp=r&st=2022-09-01T06:42:51Z&se=2022-10-29T14:42:51Z&spr=https&sv=2021-06-08&sr=b&sig=42IB%2FHHTckIUDdmkq3PooGyEVw9uI2wHEevPdpYAbY4%3D```

Run the script from a terminal session on the Custom DNS VM ```powershell -ExecutionPolicy Bypass -File dns.ps1``` to install and configure a DNS server on this machine. Contents of the script file are reproduced below. 

```

Install-WindowsFeature -Name DNS -IncludeManagementTools 
Add-DnsServerPrimaryZone -Name "cnn.com" -ZoneFile "cnn.com.dns"
Add-DnsServerResourceRecord -ZoneName "cnn.com" -A -Name "cnn.com" -AllowUpdateAny -IPv4Address "1.2.3.5" -TimeToLive 01:00:00 -AgeRecord
Add-DnsServerForwarder -IPAddress 168.63.129.16 -PassThru
```

# Create VPN / Bastion / Jumpbox

```

az deployment group create --name Step03Jumpbox --resource-group $amlrg --template-file .\steps\03-aml\jumpbox.bicep --parameters adminUsername="amljumpboxadmin01" --parameters adminUserPassword="amlH0!mJhBy3"
```

# Create Route Table

```

$fwName = $(az deployment group show -g $corerg --name Step02Firewall --query properties.outputs.firewallName.value).Trim('"')

Write-Host $fwName

$fwIP = $(az network firewall show -g $corerg --name $fwName --query ipConfigurations[0].privateIpAddress).Trim('"')

Write-Host $fwIP

az deployment group create --name Step03RouteTables --resource-group $corerg --template-file .\steps\03-aml\routetables.bicep --parameters firewallPrivateIPAddress=$fwIP

az network vnet subnet update -g $corerg -n mlsubnet --vnet-name amlspoke-vnet --route-table mlsubnetRouteTable

az network vnet subnet update -g $corerg -n jumpboxsubnet --vnet-name amlspoke-vnet --route-table jumpboxsubnetRouteTable

```

# Optional Steps

## Azure Monitor Integration
Once the Azure Firewall and AML are deployed you may want to integrate with Azure Monitor logs. This can be done via the portal, CLI or bice templates







