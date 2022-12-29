param resourcetype string
param environment string
param region string
param instance string
param tags object
var functionAppName = 'asp${resourcetype}swo${environment}${region}${instance}'
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

  resource azHostingPlan 'Microsoft.Web/serverfarms@2022-03-01' = {
    name: functionAppName
    location: '${locid[region].location}'
    kind: 'linux'
    sku: {
      name: 'S1'
    }
    properties:{
      reserved: true
    }
  tags:union(tags, {
    Enviroment: '${envtag[environment].envtag}'
  })}
output hostingplanId string = azHostingPlan.id
