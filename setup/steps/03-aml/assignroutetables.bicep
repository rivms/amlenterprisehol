
var virtualNetworkResourceGroupName = 'amlholhub-dev-rg'

var jumpboxSubnetName = 'jumpboxsubnet'
//var subnetPrefix = '10.1.2.0/27'
var virtualNetworkName = 'amlspoke-vnet'

var mlSubnetName = 'mlsubnet'


resource virtualNetwork 'Microsoft.Network/virtualNetworks@2019-11-01' existing = {
  name: virtualNetworkName
  scope: resourceGroup(virtualNetworkResourceGroupName) 

  resource jumpboxSubnet 'subnets' existing = {
    name: jumpboxSubnetName
  }

  resource mlSubnet 'subnets' existing = {
    name: mlSubnetName
  }
}
