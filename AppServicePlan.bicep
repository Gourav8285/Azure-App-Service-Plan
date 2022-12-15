
@description('Enter the location')
param location string

@description('Name the Plan')
param appServicePlanName string

@description('Enter the SKU')
param sku string

@description('Select the Kind')
param kind string
resource appServicePlan 'Microsoft.Web/serverfarms@2020-06-01' = {
  name: appServicePlanName
  location: location
  properties: {
    reserved: true
  }
  sku: {
    name: sku
  }
  kind: kind
}
