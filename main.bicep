param location string = 'japaneast'
param appServicePlanName string
param webAppName string 
param storageAccountName string
param uamiSaName string
param uamiCiCdName string
param keyVaultName string
param tags object

module webAppModule './modules/webApp/webApp.bicep' = {
  name: 'webAppModule'
  params: {
    location: location
    appServicePlanName: appServicePlanName
    webAppName: webAppName
    tags: tags
  }
}

module storageAccountModule './modules/storageAccount/storageAccount.bicep' = {
  name: 'storageAccountModule'
  params: {
    location: location
    storageAccountName: storageAccountName
    tags: tags
  }
}

module uamiModule './modules/uami/uami.bicep' = {
  name: 'uamiModule'
  params: {
    location: location
    uamiSaName: uamiSaName
    uamiCiCdName: uamiCiCdName
    webAppName: webAppName
    storageAccountName: storageAccountName
  }
  dependsOn: [
    webAppModule
    storageAccountModule
  ]
}

module keyVaultModule './modules/keyVault/keyVault.bicep' = {
  name: 'keyVaultModule'
  params: {
    keyVaultName: keyVaultName
    location: location
  }
}
