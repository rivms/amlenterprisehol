param location string = resourceGroup().location

var virtualNetworkName = 'hub-vnet'
var subnet1Name = 'GatewaySubnet'
var subnet2Name = 'AzureBastionSubnet'
var subnetHubVM = 'HubvVMSubnet'
var subnetFirewall = 'AzureFirewallSubnet'
var vpnGatewayName = 'vpngateway'
var vpnPipName = 'vpnpip01'

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.1.0.0/16'
      ]
    }
    subnets: [
      {
        name: subnet1Name
        properties: {
          addressPrefix: '10.1.0.0/24'
        }
      }
      {
        name: subnet2Name
        properties: {
          addressPrefix: '10.1.1.0/27'
        }
      }
      {
        name: subnetHubVM
        properties: {
          addressPrefix: '10.1.2.0/27'
        }
      }
      {
        name: subnetFirewall
        properties: {
          addressPrefix: '10.1.3.0/26'
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

  resource subnet3 'subnets' existing = {
    name: subnetHubVM
  }

  resource subnet4 'subnets' existing = {
    name: subnetFirewall
  }
}


resource vpnPip 'Microsoft.Network/publicIPAddresses@2022-01-01' = {
  name: vpnPipName
  location: location
  sku: {
    name: 'Basic'
    tier: 'Regional'
  }
}

resource vpnGateway 'Microsoft.Network/virtualNetworkGateways@2022-01-01' = {
  name: vpnGatewayName
  location: location
  properties: {
    activeActive: false
    gatewayType: 'Vpn'
    vpnType: 'RouteBased'
    vpnGatewayGeneration: 'Generation1'
    sku: {
      name: 'Basic'
      tier: 'Basic'
    }
    ipConfigurations:  [
      {
        name: 'default'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: virtualNetwork::subnet1.id
          }
          publicIPAddress: {
            id: vpnPip.id
          }
        }
      }
    ]
  }

}

output subnet1ResourceId string = virtualNetwork::subnet1.id
output subnet2ResourceId string = virtualNetwork::subnet2.id
