# Pre-Requisites
Install the Azure CLI tool
Switch directory to the ```setup``` folder and run the commands shown below from a Powershell terminal. 

# Create Resource Groups

```
$corerg="amlholhub-dev-rg"
$amlrg="amlwsholspoke-dev-rg"

az group create --location eastus --name $corerg
az group create --location eastus --name $amlrg
```

# Create Virtual Networks and Subnet
```
az deployment group create --name Step01Hub --resource-group $corerg --template-file ./steps/01-vnet/hub.bicep
az deployment group create --name Step01Spoke --resource-group $corerg --template-file ./steps/01-vnet/amlspoke.bicep
```

```
az deployment group create --name Step01VNetPeeringHub --resource-group $corerg --template-file ./steps/01-vnet/hubtospokepeering.bicep
az deployment group create --name Step01VNetPeeringSpoke --resource-group $corerg --template-file ./steps/01-vnet/spoketohubpeering.bicep
```

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
az deployment group create --name Step02 --resource-group $corerg --template-file .\steps\02-firewall\customdns.bicep --parameters adminUsername="amlholadmin02" --parameters adminUserPassword="amlH0!mJhBy3"
```

# Configure DNS Forwarder
Using Bastion connect to the DNS VM. Run the contents of the ```dns.ps1``` script to install and configure a DNS server on this machine. Contents of the script file are reproduced below. 

```
Install-WindowsFeature -Name DNS -IncludeManagementTools 
Add-DnsServerPrimaryZone -Name "cnn.com" -ZoneFile "cnn.com.dns"
Add-DnsServerResourceRecord -ZoneName "cnn.com" -A -Name "cnn.com" -AllowUpdateAny -IPv4Address "1.2.3.5" -TimeToLive 01:00:00 -AgeRecord
```

# Create VPN / Bastion / Jumpbox

```
az deployment group create --name Step03Jumpbox --resource-group $amlrg --template-file .\steps\03-aml\jumpbox.bicep --parameters adminUsername="amljumpboxadmin01" --parameters adminUserPassword="amlH0!mJhBy3"
```

# Monitoring

```
az deployment group create --name Step02Firewall --resource-group $corerg --template-file ./steps/04-monitoring/azuremonitorlogs.bicep

```

```
az deployment group create --name Step02Firewall --resource-group $corerg --template-file ./steps/04-monitoring/azuremonitorexportlogsfw.bicep

```

# Optional Steps

## AML Azure Monitor Integration
Once AML is deployed you may want to integrate with Azure Monitor logs. This can be done via the portal or using the sample script below

```
az deployment group create --name Step02Firewall --resource-group $corerg --template-file ./steps/04-monitoring/azuremonitorexportlogsaml.bicep

```







