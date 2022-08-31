

@description('Azure Firewall name')
param workspaceName string = 'amllaw${uniqueString(subscription().subscriptionId, resourceGroup().id)}'

@description('Location for all resources.')
param location string = resourceGroup().location

resource workspaceName_resource 'Microsoft.OperationalInsights/workspaces@2021-12-01-preview' = {
  name: workspaceName
  location: location
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: 30
    features: {
      immediatePurgeDataOn30Days: true
    }
  }
}
