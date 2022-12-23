targetScope = 'subscription'

param resourcetype string
param environment string
param region string
param instance1 string
param instance2 string
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

var rgname1 = 'rgswo${resourcetype}${environment}${region}${instance1}'
var rgname2 = 'rgswo${resourcetype}${environment}${region}${instance2}'
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
  name: rgname1
  location: location
  tags: union(tags,{
    Environment : '${envtag[environment].envtag}'
  })
  managedBy:''
  properties:{}
}

resource resourcegroup2 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: rgname2
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
    instance1:instance1
    region: region
    resourcetype: resourcetype
    tags: tags
     sku:sku
  }
}
module appServicePlan2 'AppServicePlan2.bicep' = {
  scope: resourcegroup2
  name: resourcetype
  params: {
    environment: environment
    instance2: instance2
    region: region
    resourcetype: resourcetype
    tags: tags
     sku:sku
  }}
