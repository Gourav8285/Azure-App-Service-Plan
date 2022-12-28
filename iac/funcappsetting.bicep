param functionAppName string
param azStorageAccount object
param appInsightsKey string


resource functionAppAppsettings 'Microsoft.Web/sites/config@2018-11-01' = {
  name: 'fncswodevwe1/appsettings'
  properties: {
    CustomerApiKey: 'This is the function app setting'
    AzureWebJobsStorage: 'DefaultEndpointsProtocol=https;AccountName=stor198;AccountKey=bnPdgh25X9nhwHx+UK933VDtlly5jx9m4e+sUMurZxSVTxIOHJAJTw/qKqO6s2UTFMpr/hHbAgTV+AStn4M+HQ==;EndpointSuffix=core.windows.net'
    WEBSITE_CONTENTAZUREFILECONNECTIONSTRING: 'DefaultEndpointsProtocol=https;AccountName=stor198;AccountKey=bnPdgh25X9nhwHx+UK933VDtlly5jx9m4e+sUMurZxSVTxIOHJAJTw/qKqO6s2UTFMpr/hHbAgTV+AStn4M+HQ==;EndpointSuffix=core.windows.net'
    WEBSITE_CONTENTSHARE: toLower(functionAppName)
    FUNCTIONS_EXTENSION_VERSION: '~3'
    APPINSIGHTS_INSTRUMENTATIONKEY: appInsightsKey
    FUNCTIONS_WORKER_RUNTIME: 'dotnet'
    WEBSITE_TIME_ZONE: 'AUS Eastern Standard Time'
    WEBSITE_ADD_SITENAME_BINDINGS_IN_APPHOST_CONFIG: 1
}}
