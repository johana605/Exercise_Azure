param location string = 'eastus'
param appServicePlanName string = 'asrecurso'
param resourceGroupName string = 'rgworkmil'
param subscriptionId string = 'efa43193-61b3-42cf-a087-6681f44edf7c'

resource appServicePlan 'Microsoft.Web/serverfarms@2021-01-15' = {
  name: appServicePlanName
  location: location
  kind: 'app'
  sku: {
    name: 'F1'
    tier: 'Free'
  }
}

output appServicePlanId string = appServicePlan.id
