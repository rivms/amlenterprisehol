param pveName string
param pveVnetName string
param pveVnetGroup string
param privateDnsZoneName string

resource pveVnet 'Microsoft.Network/virtualNetworks@2021-05-01' existing = {
  name: pveVnetName
  scope: resourceGroup(pveVnetGroup)
}


resource privateEndpoint 'Microsoft.Network/privateEndpoints@2021-08-01' existing = {
  name: pveName
}

// Create Private DNS zone "privatelink.blob.core.windows.net'
resource privateDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: privateDnsZoneName
  location: 'global'
  dependsOn: [
    pveVnet
  ]
}

resource privateDnsZoneLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  parent: privateDnsZone
  name: '${privateDnsZone.name}-link'
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: pveVnet.id
    }
  }
}

resource privateDnsZoneGroup 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2021-08-01' = {
  parent: privateEndpoint
  name: 'default'
  properties: {
    privateDnsZoneConfigs: [
      {
        name: 'config1'
        properties: {
          privateDnsZoneId: privateDnsZone.id
        }
      }
    ]
  }
}
