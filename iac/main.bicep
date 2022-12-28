targetScope = 'subscription'
param resourcetype string
param environment string
param region string
param instance string
param tags object
var functionAppinsiName = 'ap${resourcetype}swo${environment}${region}${instance}'
var stName = 'st${resourcetype}swo${environment}${region}${instance}'
var rgname = 'rgswo${resourcetype}${environment}${region}${instance}'

var locid = {
  we: {
    location : 'westeurope'
  }
  ne :{
    location : 'northeurope'
  }
}

var functionAppName = '${resourcetype}swo${environment}${region}${instance}'
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
  location: '${locid[region].location}'
  tags: union(tags,{
    Environment : '${envtag[environment].envtag}'
  })
  managedBy:''
  properties:{}
}

module storage 'storage.bicep' = {
  name: stName
  scope:resourcegroup
  params: {
    environment: environment
    instance: instance
    principalId: funcapp.outputs.managedid
    region: region
    resourcetype: resourcetype
    tags: tags
  }}

module hostingplanmodule 'hostingplan.bicep' =  {
  name: functionAppName
  scope:resourcegroup
  params: {
    environment: environment
    instance: instance
    region: region
    resourcetype: resourcetype
    tags: tags
  }
}

module funcapp 'functionapp.bicep' = {
  name:functionAppName
  scope:resourcegroup
  params: {
    tags: tags
     serverFarmId:hostingplanmodule.outputs.hostingplanId
    environment: environment
    instance: instance
    region: region
    resourcetype: resourcetype
  }
}

module appinsi 'appinsight.bicep' = {
   name:functionAppinsiName
   scope:resourcegroup
   params: {
    tags: tags
    environment: environment
    instance: instance
    region: region
    resourcetype: resourcetype
   }
}

module appsetting 'funcappsetting.bicep' = {
  name: '${functionAppName}/appsettings'
  scope:resourcegroup
  params: {
    appInsightsKey: appinsi.outputs.appInsightsKey
    azStorageAccount: storage.outputs.azStorageAccountName
    functionAppName: functionAppName
  }
}
