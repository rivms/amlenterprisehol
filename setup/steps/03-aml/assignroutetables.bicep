
@description('Route table name')
param mlRouteTableName string = 'mlsubnetRouteTable'

@description('Route table name')
param jumpboxRouteTableName string = 'jumpboxsubnetRouteTable'

var virtualNetworkResourceGroupName = 'amlholhub-dev-rg'

var jumpboxSubnetName = 'jumpboxsubnet'
//var subnetPrefix = '10.1.2.0/27'
var virtualNetworkName = 'amlspoke-vnet'

var mlSubnetName = 'mlsubnet'

resource mlRouteTable 'Microsoft.Network/routeTables@2020-11-01' existing = {
  name: mlRouteTableName
}

resource jumpboxsubnetRouteTable 'Microsoft.Network/routeTables@2020-11-01' existing = {
  name: jumpboxRouteTableName
}

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: virtualNetworkName
  scope: resourceGroup(virtualNetworkResourceGroupName) 

  properties: {

  }

  resource jumpboxSubnet 'subnets' existing = {
    name: jumpboxSubnetName
  }

  resource mlSubnet 'subnets' existing = {
    name: mlSubnetName
  }
}


