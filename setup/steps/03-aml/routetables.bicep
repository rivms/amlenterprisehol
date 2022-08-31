

@description('Azure Firewall name')
param firewallPrivateIPAddress string = '10.1.3.4'

@description('Location for all resources.')
param location string = resourceGroup().location


@description('Route table name')
param mlRouteTableName string = 'mlsubnetRouteTable'

@description('Route table name')
param jumpboxRouteTableName string = 'jumpboxsubnetRouteTable'

resource mlRouteTable 'Microsoft.Network/routeTables@2020-11-01' = {
  name: mlRouteTableName
  location: location
  properties: {
    disableBgpRoutePropagation: false
    routes: [
      {
       name: 'AzfwDefaultRoute'
        properties: {
          addressPrefix: '0.0.0.0/0'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: firewallPrivateIPAddress
        }
      }
    ]
  }
}

resource jumpboxsubnetRouteTable 'Microsoft.Network/routeTables@2020-11-01' = {
  name: jumpboxRouteTableName
  location: location
  properties: {
    disableBgpRoutePropagation: false
    routes: [
      {
       name: 'AzfwDefaultRoute'
        properties: {
          addressPrefix: '0.0.0.0/0'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: firewallPrivateIPAddress
        }
      }
    ]
  }
}

