param location string = resourceGroup().location
param pveVnetName string 
param pveVnetGroup string
param pveSubnetName string
param pveName string

param storageName string
param acrName string

//var blobpveName = '${storageName}pveblob'
var privateDnsZoneNameBlobStorage = 'privatelink.blob.${environment().suffixes.storage}'
var privateDnsZoneNameFileStorage = 'privatelink.file.${environment().suffixes.storage}'
var privateDnsZoneNameTableStorage = 'privatelink.table.${environment().suffixes.storage}'
var privateDnsZoneNameQueueStorage = 'privatelink.queue.${environment().suffixes.storage}'
var privateDnsZoneNameAcr = 'privatelink${environment().suffixes.acrLoginServer}'


//output childAddressPrefix string = pveSubnet.properties.addressPrefix
output test string = pveVnet::pvtendpsubnet.properties.privateEndpointNetworkPolicies


// var blob = resourceId(resourceType)

// References for existing resources
resource pveVnet 'Microsoft.Network/virtualNetworks@2021-05-01' existing = {
  name: pveVnetName
  scope: resourceGroup(pveVnetGroup)

  resource pvtendpsubnet 'subnets' existing =  {
    name: pveSubnetName
  }
}



resource privateEndpointBlob 'Microsoft.Network/privateEndpoints@2021-08-01' = {
  name: '${pveName}Blob'
  location: location
  properties: {
    subnet: {
      id: pveVnet::pvtendpsubnet.id
    }
    privateLinkServiceConnections: [
      {
        name: pveName
        properties: {
          privateLinkServiceId: amlstorage.id
          groupIds: [
            'blob'
          ]
        }
      }
    ]
  }
}

module pveModuleBlob './privateDnsZone.bicep' = {
  name: 'blobDnsZoneDeploy'
  params: {
    pveName: privateEndpointBlob.name
    pveVnetName: pveVnet.name
    pveVnetGroup: pveVnetGroup
    privateDnsZoneName: privateDnsZoneNameBlobStorage
  }
}

resource privateEndpointFile 'Microsoft.Network/privateEndpoints@2021-08-01' = {
  name: '${pveName}File'
  location: location
  properties: {
    subnet: {
      id: pveVnet::pvtendpsubnet.id
    }
    privateLinkServiceConnections: [
      {
        name: pveName
        properties: {
          privateLinkServiceId: amlstorage.id
          groupIds: [
            'file'
          ]
        }
      }
    ]
  }
}

module pveModuleFile './privateDnsZone.bicep' = {
  name: 'filebDnsZoneDeploy'
  params: {
    pveName: privateEndpointFile.name
    pveVnetName: pveVnet.name
    pveVnetGroup: pveVnetGroup
    privateDnsZoneName: privateDnsZoneNameFileStorage
  }
}


resource privateEndpointTable 'Microsoft.Network/privateEndpoints@2021-08-01' = {
  name: '${pveName}Table'
  location: location
  properties: {
    subnet: {
      id: pveVnet::pvtendpsubnet.id
    }
    privateLinkServiceConnections: [
      {
        name: pveName
        properties: {
          privateLinkServiceId: amlstorage.id
          groupIds: [
            'table'
          ]
        }
      }
    ]
  }
}


module pveModuleTable './privateDnsZone.bicep' = {
  name: 'tablebDnsZoneDeploy'
  params: {
    pveName: privateEndpointTable.name
    pveVnetName: pveVnet.name
    pveVnetGroup: pveVnetGroup
    privateDnsZoneName: privateDnsZoneNameTableStorage
  }
}

resource privateEndpointQueue 'Microsoft.Network/privateEndpoints@2021-08-01' = {
  name: '${pveName}Queue'
  location: location
  properties: {
    subnet: {
      id: pveVnet::pvtendpsubnet.id
    }
    privateLinkServiceConnections: [
      {
        name: pveName
        properties: {
          privateLinkServiceId: amlstorage.id
          groupIds: [
            'queue'
          ]
        }
      }
    ]
  }
}


module pveModuleQueue './privateDnsZone.bicep' = {
  name: 'queueDnsZoneDeploy'
  params: {
    pveName: privateEndpointQueue.name
    pveVnetName: pveVnet.name
    pveVnetGroup: pveVnetGroup
    privateDnsZoneName: privateDnsZoneNameQueueStorage
  }
}


/*

// Create Private DNS zone "privatelink.blob.core.windows.net'
resource privateDnsZoneBlob 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: privateDnsZoneNameBlobStorage
  location: 'global'
  dependsOn: [
    pveVnet
  ]
}

resource privateDnsZoneLinkBlob 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  parent: privateDnsZoneBlob
  name: '${privateDnsZoneBlob.name}-link'
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: pveVnet.id
    }
  }
}

resource privateDnsZoneGroup 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2021-08-01' = {
  parent: privateEndpointBlob
  name: 'default'
  properties: {
    privateDnsZoneConfigs: [
      {
        name: 'config1'
        properties: {
          privateDnsZoneId: privateDnsZoneBlob.id
        }
      }
    ]
  }
}
*/
resource amlstorage 'Microsoft.Storage/storageAccounts@2021-09-01' = {
  name: storageName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    allowBlobPublicAccess: false

  }
}

/*
resource storagepveblob 'Microsoft.Network/privateEndpoints@2021-08-01' = {
  name: blobpveName
  location: location
  properties: {
    subnet: {

    }
  }
}
*/
resource amlacr 'Microsoft.ContainerRegistry/registries@2021-12-01-preview' = {
  name: acrName
  location: location
  sku: {
    name: 'Premium'
  }
}


resource privateEndpointAcr 'Microsoft.Network/privateEndpoints@2021-08-01' = {
  name: privateDnsZoneNameAcr
  location: location
  properties: {
    subnet: {
      id: pveVnet::pvtendpsubnet.id
    }
    privateLinkServiceConnections: [
      {
        name: amlacr.name
        properties: {
          privateLinkServiceId: amlacr.id
          groupIds: [
            'registry'
          ]
        }
      }
    ]
  }
}

module pveModuleAcr './privateDnsZone.bicep' = {
  name: 'acrbDnsZoneDeploy'
  params: {
    pveName: privateEndpointAcr.name
    pveVnetName: pveVnet.name
    pveVnetGroup: pveVnetGroup
    privateDnsZoneName: privateDnsZoneNameAcr
  }
}
