param functionAppName string
param azStorageAccount object
param appInsightsKey string

resource functionApp 'Microsoft.Web/sites@2022-03-01' existing = {
  name: functionAppName
}

resource functionAppAppsettings 'Microsoft.Web/sites/config@2018-11-01' = {
  name: 'appsettings'
  parent:functionApp
  properties: {
    CustomerApiKey: 'This is the function app setting'
    AzureWebJobsStorage: 'DefaultEndpointsProtocol=https;AccountName=${azStorageAccount.name};EndpointSuffix=${az.environment().suffixes.storage};AccountKey=${listKeys(azStorageAccount.id, azStorageAccount.apiVersion).keys[0].value}'
    WEBSITE_CONTENTAZUREFILECONNECTIONSTRING: 'DefaultEndpointsProtocol=https;AccountName=${azStorageAccount.name};EndpointSuffix=${az.environment().suffixes.storage};AccountKey=${listKeys(azStorageAccount.id, azStorageAccount.apiVersion).keys[0].value}'
    WEBSITE_CONTENTSHARE: toLower(functionAppName)
    FUNCTIONS_EXTENSION_VERSION: '~3'
    APPINSIGHTS_INSTRUMENTATIONKEY: appInsightsKey
    FUNCTIONS_WORKER_RUNTIME: 'dotnet'
    WEBSITE_TIME_ZONE: 'AUS Eastern Standard Time'
    WEBSITE_ADD_SITENAME_BINDINGS_IN_APPHOST_CONFIG: '1'
}}
