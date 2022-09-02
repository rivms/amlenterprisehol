
@description('Azure Firewall name')
param firewallName string = 'amlfw${uniqueString(subscription().subscriptionId, resourceGroup().id)}'

@description('Azure Firewall policy name')
param firewallPolicyName string = '${firewallName}-firewallPolicy'

@description('Location for all resources.')
param location string = resourceGroup().location

resource firewallPolicy 'Microsoft.Network/firewallPolicies@2022-01-01'existing = {
  name: firewallPolicyName
}


//resource firewall 'Microsoft.Network/azureFirewalls@2021-03-01' existing = {
//  name: firewallName
//}

resource hubvnetIpGroup 'Microsoft.Network/ipGroups@2022-01-01' = {
  name: 'hubvnetIpGroup'
  location: location
  properties: {
    ipAddresses: [
      '10.1.0.0/16'
    ]
  }
}

resource amlspokeIpGroup 'Microsoft.Network/ipGroups@2022-01-01' = {
  name: 'amlspokeIpGroup'
  location: location
  properties: {
    ipAddresses: [
      '10.2.0.0/16'
    ]
  }
}

resource mlsubnetAmlspokeIpGroup 'Microsoft.Network/ipGroups@2022-01-01' = {
  name: 'mlsubnetAmlspokeIpGroup'
  location: location
  properties: {
    ipAddresses: [
      '10.2.0.0/24'
    ]
  }
}

resource jumpboxsubnetAmlspokeIpGroup 'Microsoft.Network/ipGroups@2022-01-01' = {
  name: 'jumpboxsubnetAmlspokeIpGroup'
  location: location
  properties: {
    ipAddresses: [
      '10.2.2.0/24'
    ]
  }
}

// HubvVMSubnet
resource HubvVMSubnetAmlspokeIpGroup 'Microsoft.Network/ipGroups@2022-01-01' = {
  name: 'HubvVMSubnetAmlspokeIpGroup'
  location: location
  properties: {
    ipAddresses: [
      '10.1.2.0/27'
    ]
  }
}

resource applicationRuleCollectionGroup 'Microsoft.Network/firewallPolicies/ruleCollectionGroups@2022-01-01' = {
  parent: firewallPolicy
  name: 'DefaultApplicationRuleCollectionGroup'
  properties: {
    priority: 300
    ruleCollections: [
      {
        ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
        action: {
          type: 'Allow'
        }
        name: 'Global-rules-arc'
        priority: 1202
        rules: [
          {
            ruleType: 'ApplicationRule'
            name: 'global-rule-01'
            protocols: [
              {
                protocolType: 'Https'
                port: 443
              }
            ]
            targetFqdns: [
              'www.microsoft.com'
            ]
            terminateTLS: false
            sourceIpGroups: [
              mlsubnetAmlspokeIpGroup.id
              jumpboxsubnetAmlspokeIpGroup.id
              HubvVMSubnetAmlspokeIpGroup.id
            ]
          }
          {
            ruleType: 'ApplicationRule'
            name: 'global-rule-02'
            protocols: [
              {
                protocolType: 'Https'
                port: 443
              }
            ]
            targetFqdns: [
              'amlholst001.blob.${environment().suffixes.storage}'
            ]
            terminateTLS: false
            sourceIpGroups: [
              mlsubnetAmlspokeIpGroup.id
              jumpboxsubnetAmlspokeIpGroup.id
              HubvVMSubnetAmlspokeIpGroup.id
            ]
          }
        ]
      }
    ]
  }
}
