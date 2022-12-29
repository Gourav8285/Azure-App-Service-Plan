param resourcetype string
param environment string
param region string
param instance string
param tags object

var locid = {
  we: {
    location : 'westeurope'
  }
  ne :{
    location : 'northeurope'
  }
}
var envtag = {
  dev: {
    envtag : 'development'
  }
  prd:{
    envtag : 'production'
  }
}
var functionAppName = 'ai${resourcetype}swo${environment}${region}${instance}'
resource appInsight 'Microsoft.Insights/components@2020-02-02'= {
  name:functionAppName
  kind:'web'
  location:'${locid[region].location}'
  properties:{
    Application_Type:'web'
    Request_Source:'rest'
    Flow_Type:'Bluefield'
    // WorkspaceResourceId: logAnalyticsWorkspace.id >> TBA
  }
  tags:union(tags, {
    Enviroment: '${envtag[environment].envtag}'})
}
output appInsightsKey string = reference(appInsight.id, '2014-04-01').InstrumentationKey
