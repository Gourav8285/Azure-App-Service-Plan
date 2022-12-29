targetScope = 'subscription'
param resourcetype string
param environment string
param region string
param instance string
param tags object
var functionAppinsiName = 'aapi${resourcetype}swo${environment}${region}${instance}'
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
var hostingplanName = 'asp${resourcetype}swo${environment}${region}${instance}'
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

module storage 'Resources/storage.bicep' = {
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

module hostingplanmodule 'Resources/hostingplan.bicep' = {
  name: hostingplanName
  scope: resourcegroup
  params: {
    environment: environment
    instance: instance
    region: region
    resourcetype: resourcetype
    tags: tags
  }
}

module funcapp 'Resources/functionapp.bicep' = {
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

module appinsi 'Resources/appinsight.bicep' = {
   name:functionAppinsiName
   scope:resourcegroup
   params: {
    tags: tags
    environment: environment
    instance: instance
    region: region
    resourcetype: resourcetype
   }
   dependsOn:[
    funcapp
   ]
}

module appsetting 'Resources/funcappsetting.bicep' = {
  name: 'appsettings'
  scope:resourcegroup
  params: {
    appInsightsKey: appinsi.outputs.appInsightsKey
    blobStorageConnectionString: storage.outputs.blobStorageConnectionString
    functionAppName: toLower(functionAppName)
  }
  dependsOn:[
    storage
    funcapp
    appinsi
  ]
}
