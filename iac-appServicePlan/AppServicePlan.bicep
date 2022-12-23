targetScope = 'resourceGroup'

param resourcetype string
param environment string
param region string
param instance1 string
param tags object
param sku string

var locid = {
  we: {
    location : 'westeurope'
  }
  ne :{
    location : 'northeurope'
  }
}

var appServicePlanName = '${resourcetype}swo${environment}${region}${instance1}'
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
  sku:{
    name:sku
  }

  tags: union(tags, {
    Enviroment: '${envtag[environment].envtag}'
  })
  kind: 'Linux'
}
