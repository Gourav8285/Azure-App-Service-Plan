param resourcetype string
param environment string
param region string
param instance string
param tags object
var functionAppName = '${resourcetype}swo${environment}${region}${instance}'
param serverFarmId string
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

resource functionAppResource 'Microsoft.Web/sites@2020-12-01' = {
  name: functionAppName
  identity:{
    type:'SystemAssigned'    
  }
  properties:{
    reserved:true
    serverFarmId:serverFarmId
  }
  location: '${locid[region].location}'
  kind: 'functionapp'
  tags:union(tags, {
    Enviroment: '${envtag[environment].envtag}'
  })
}
output managedid string = functionAppResource.identity.principalId


