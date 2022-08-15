# Create Resource Groups
$corerg="amlholcore-dev-rg"
$amlrg="amlholws-dev-rg"

az group create --location eastus --name $corerg
az group create --location eastus --name $amlrg

# Create Virtual Networks

az deployment group create --name Step01 --resource-group $corerg --template-file ./steps/01-vnet/hub.bicep

## Create Subnets

# Create Azure Firewall

# Create VPN / Bastion / Jumpbox

# Create Workspace Resources

# Create Firewall Rules

# Create Route Table

# Create AML Workspace

