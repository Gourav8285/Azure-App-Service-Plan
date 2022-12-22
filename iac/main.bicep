targetScope = 'subscription'

param resourcetype string
param environment string
param region string
param instance string
param tags object
param skuid string

var locid = {
  we: {
    location : 'westeurope'
  }
  ne :{
    location : 'northeurope'
  }
}

var rgname = 'rgswo${resourcetype}${environment}${region}${instance}'
var location = '${locid[region].location}'
var envtag = {
  dev: {
    envtag : 'development'
  }
  prd:{
    envtag : 'production'
  }
}

resource resourcegroup 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: rgname
  location: location
  tags: union(tags,{
    Environment : '${envtag[environment].envtag}'
  })
  managedBy:''
  properties:{}
}

module appServicePlan 'AppServicePlan.bicep' = {
  scope: resourcegroup
  name: resourcetype
  params: {
    environment: environment
    instance: instance
    region: region
    resourcetype: resourcetype
    tags: tags
    skuid:skuid
  }
}
