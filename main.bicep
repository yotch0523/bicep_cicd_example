param location string = 'japaneast'
param appServicePlanName string
param webAppName string 
param storageAccountName string
param uamiSaName string
param uamiCiCdName string
param keyVaultName string
param tags object

module webAppModule1 './modules/webApp/main.bicep' = {
  name: 'webAppModule1'
  params: {
    location: location
    appServicePlanName: appServicePlanName
    webAppName: '${webAppName}-1'
    tags: tags
  }
}

module webAppModule2 './modules/webApp/main.bicep' = {
  name: 'webAppModule2'
  params: {
    location: location
    appServicePlanName: appServicePlanName
    webAppName: '${webAppName}-2'
    tags: tags
  }
}

module storageAccountModule './modules/storageAccount/main.bicep' = {
  name: 'storageAccountModule'
  params: {
    location: location
    storageAccountName: storageAccountName
    tags: tags
  }
}

module uamiModule './modules/uami/main.bicep' = {
  name: 'uamiModule'
  params: {
    location: location
    uamiSaName: uamiSaName
    uamiCiCdName: uamiCiCdName
    webAppName: '${webAppName}-1'
    storageAccountName: storageAccountName
  }
  dependsOn: [
    webAppModule1
    webAppModule2
    storageAccountModule
  ]
}

module keyVaultModule './modules/keyVault/main.bicep' = {
  name: 'keyVaultModule'
  params: {
    keyVaultName: keyVaultName
    location: location
  }
}
