
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

var stName = 'st${resourcetype}swo${environment}${region}${instance}'
resource azStorageAccount 'Microsoft.Storage/storageAccounts@2022-05-01' = {
  name: stName
  location: '${locid[region].location}'
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  identity:{
    type:'SystemAssigned'
    
  }
tags:union(tags, {
  Enviroment: '${envtag[environment].envtag}'
})}

param principalId string

resource OwnerRoleDefinition 'Microsoft.Authorization/roleDefinitions@2018-01-01-preview' existing = {
  scope: azStorageAccount
  name: '17d1049b-9a84-46fb-8f53-869881c3d3ab'
}

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid(resourceGroup().id, principalId, OwnerRoleDefinition.id)
  properties: {
    roleDefinitionId: OwnerRoleDefinition.id
    principalId: principalId
    principalType: 'ServicePrincipal'
  }
}
// output azStorageAccountName object = azStorageAccount
var blobStorageConnectionString = 'DefaultEndpointsProtocol=https;AccountName=${azStorageAccount.name};EndpointSuffix=${az.environment().suffixes.storage};AccountKey=${listKeys(azStorageAccount.id, azStorageAccount.apiVersion).keys[0].value}'

output blobStorageConnectionString string = blobStorageConnectionString
