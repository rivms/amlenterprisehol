
var hubVirtualNetworkName = 'hub-vnet'
var spokeVirtualNetworkName = 'amlspoke-vnet'

resource spokeVNET 'Microsoft.Network/virtualNetworks@2019-11-01' existing = {
  name: spokeVirtualNetworkName
}

resource spoke_peering_to_remote_hub 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2021-02-01' = {
  name: '${hubVirtualNetworkName}/peering-hub-to-spoke-vnet'
  properties: {
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: true
    useRemoteGateways: false
    remoteVirtualNetwork: {
      id: spokeVNET.id
    }
  }
}
