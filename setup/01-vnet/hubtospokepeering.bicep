
var hubVirtualNetworkName = 'hub-vnet'
var spokeVirtualNetworkName = 'amlspoke-vnet'
// var hubVnetReesourceGroup = 'amlholcore-dev-rg'
var spokeVnetResourceGroup = 'amlholcore-dev-rg'


resource spoke_peering_to_remote_hub 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2021-02-01' = {
  name: '${hubVirtualNetworkName}/peering-hub-to-spoke-vnet'
  properties: {
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: true
    useRemoteGateways: false
    remoteVirtualNetwork: {
      id: resourceId(spokeVnetResourceGroup, 'Microsoft.Network/virtualNetworks', spokeVirtualNetworkName)
    }
  }
}
