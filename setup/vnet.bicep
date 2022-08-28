
@description('Provide a name for the virtual network for the hands on lab')
param vnetName string

param location string = resourceGroup().location


resource holvnet 'Microsoft.Network/virtualNetworks@2021-08-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'amlsubnet'
        properties: {
          addressPrefix: '10.0.0.0/24'
        }
      }
      {
        name: 'pvtendpsubnet'
        properties: {
          addressPrefix: '10.0.1.0/24'
          privateEndpointNetworkPolicies: 'Disabled'
        }
      }
    ]
  }
}
