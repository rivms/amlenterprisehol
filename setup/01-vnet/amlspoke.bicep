param location string = resourceGroup().location

var virtualNetworkName = 'amlspoke-vnet'
var subnet1Name = 'mlsubnet'
var subnet2Name = 'pvtlinksubnet'

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.2.0.0/16'
      ]
    }
    subnets: [
      {
        name: subnet1Name
        properties: {
          addressPrefix: '10.2.0.0/24'
        }
      }
      {
        name: subnet2Name
        properties: {
          addressPrefix: '10.2.1.0/24'
        }
      }
    ]
  }

  resource subnet1 'subnets' existing = {
    name: subnet1Name
  }

  resource subnet2 'subnets' existing = {
    name: subnet2Name
  }
}

output subnet1ResourceId string = virtualNetwork::subnet1.id
output subnet2ResourceId string = virtualNetwork::subnet2.id
