
var hubVirtualNetworkName = 'hub-vnet'
var spokeVirtualNetworkName = 'amlspoke-vnet'

resource hubVNET 'Microsoft.Network/virtualNetworks@2019-11-01' existing = {
  name: hubVirtualNetworkName
}

resource spoke_peering_to_remote_hub 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2021-02-01' = {
  name: '${spokeVirtualNetworkName}/peering-spoke-to-hub-vnet'
  properties: {
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: true
    useRemoteGateways: true
    remoteVirtualNetwork: {
      id: hubVNET.id
    }
  }
}
