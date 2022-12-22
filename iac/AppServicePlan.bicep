targetScope = 'resourceGroup'

param sku string
param resourcetype string
param environment string
param kind string
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

var appServicePlanName = '${resourcetype}swo${environment}${region}${instance}}'
var envtag = {
  dev: {
    envtag : 'development'
  }
  prd:{
    envtag : 'production'
  }
}

resource appServicePlan 'Microsoft.Web/serverfarms@2020-06-01' = {
  name: appServicePlanName
  location: '${locid[region].location}'
  properties: {
    reserved: true
  }
  sku: {
    name: sku
  }
  tags: union(tags, {
    Enviroment: '${envtag[environment].envtag}'
  })
  kind: kind
}