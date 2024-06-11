param location string = 'japaneast'
param appServicePlanName string
param webAppName string 
param storageAccountName string
param uamiSaName string
param uamiCiCdName string

module webAppModule './modules/webApp/webApp.bicep' = {
  name: 'webAppModule'
  params: {
    location: location
    appServicePlanName: appServicePlanName
    webAppName: webAppName
  }
}

module storageAccountModule './modules/storageAccount/storageAccount.bicep' = {
  name: 'storageAccountModule'
  params: {
    location: location
    storageAccountName: storageAccountName
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
