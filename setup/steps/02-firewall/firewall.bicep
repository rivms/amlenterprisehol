@description('Virtual network name')
param virtualNetworkName string = 'hub-vnet'

@description('Azure Firewall name')
param firewallName string = 'amlfw${uniqueString(subscription().subscriptionId, resourceGroup().id)}'

@description('Number of public IP addresses for the Azure Firewall')
@minValue(1)
@maxValue(100)
param numberOfPublicIPAddresses int = 1

@description('Location for all resources.')
param location string = resourceGroup().location
//param infraIpGroupName string = '${location}-infra-ipgroup-${uniqueString(resourceGroup().id)}'
//param workloadIpGroupName string = '${location}-workload-ipgroup-${uniqueString(resourceGroup().id)}'
param firewallPolicyName string = '${firewallName}-firewallPolicy'

var publicIPNamePrefix = 'publicIPFirewall'
var azurepublicIpname = publicIPNamePrefix
var azureFirewallSubnetName = 'AzureFirewallSubnet'
var azureFirewallSubnetId = resourceId('Microsoft.Network/virtualNetworks/subnets', virtualNetworkName, azureFirewallSubnetName)
var azureFirewallPublicIpId = resourceId('Microsoft.Network/publicIPAddresses', publicIPNamePrefix)
var azureFirewallIpConfigurations = [for i in range(0, numberOfPublicIPAddresses): {
  name: 'IpConf${i}'
  properties: {
    subnet: ((i == 0) ? json('{"id": "${azureFirewallSubnetId}"}') : json('null'))
    publicIPAddress: {
      id: '${azureFirewallPublicIpId}${i + 1}'
    }
  }
}]

resource vnet 'Microsoft.Network/virtualNetworks@2022-01-01' existing = {
  name: virtualNetworkName
}

//resource workloadIpGroup 'Microsoft.Network/ipGroups@2022-01-01' = {
//  name: workloadIpGroupName
//  location: location
//  properties: {
//    ipAddresses: [
//      '10.20.0.0/24'
//      '10.30.0.0/24'
//    ]
//  }
//}

//resource infraIpGroup 'Microsoft.Network/ipGroups@2022-01-01' = {
//  name: infraIpGroupName
//  location: location
//  properties: {
//    ipAddresses: [
//      '10.40.0.0/24'
//      '10.50.0.0/24'
//    ]
//  }
//}



resource publicIpAddress 'Microsoft.Network/publicIPAddresses@2022-01-01' = [for i in range(0, numberOfPublicIPAddresses): {
  name: '${azurepublicIpname}${i + 1}'
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
    publicIPAddressVersion: 'IPv4'
  }
}]

resource firewallPolicy 'Microsoft.Network/firewallPolicies@2022-01-01'= {
  name: firewallPolicyName
  location: location
  properties: {
   threatIntelMode: 'Alert'
  }
}



resource firewall 'Microsoft.Network/azureFirewalls@2022-01-01' = {
  name: firewallName
  location: location
  zones: null
  dependsOn: [
    vnet
    publicIpAddress
  ]
  properties: {
    ipConfigurations: azureFirewallIpConfigurations
    firewallPolicy: {
      id: firewallPolicy.id
    }
    hubIPAddresses: {
      privateIPAddress: '10.1.3.5'
    }
//    applicationRuleCollections: [
//      {
//        name: 'appRc1'
//        properties: {
//          priority: 101
//          action: {
//            type: 'Allow'
//          }
//          rules: [
//            {
//              name: 'appRule1'
//              protocols: [
//                {
//                  port: 80
//                  protocolType: 'Http'
//                }
//                {
//                  port: 443
//                  protocolType: 'Https'
//                }
//              ]
//              targetFqdns: [
//                'www.microsoft.com'
//              ]
//              sourceAddresses: [
//                '10.1.0.0/24'
//                '10.1.2.0/27'
//                '10.1.3.0/26'
//                '10.1.1.0/27'
//                '10.2.0.0/24'
//                '10.2.1.0/24'
//                '10.2.2.0/24'
//              ]
//            }
//          ]
//        }
//      }
//    ]
  }
}
