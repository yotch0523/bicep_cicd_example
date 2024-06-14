param location string = 'japaneast'
param webAppName string
param storageAccountName string
param uamiSaName string
param uamiCiCdName string
param tags object = {}

// get existing web app resouce object by webAppId
resource webApp 'Microsoft.Web/sites@2023-12-01' existing = {
  name: webAppName
}

resource uamiCiCd 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-07-31-preview' = {
  name: uamiCiCdName
  location: location
  tags: tags
}

resource roleAssignmentToUamiCiCd 'Microsoft.Authorization/roleAssignments@2021-04-01-preview' = {
  name: guid('webContributor', uamiCiCdName, webApp.id)
  scope: webApp
  properties: {
    principalType: 'ServicePrincipal'
    roleDefinitionId: '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/de139f84-1756-47ae-9be6-808fbbe84772'
    principalId: uamiCiCd.properties.principalId
  }
}

resource uamiCiCdFederatedIdentityCredential 'Microsoft.ManagedIdentity/userAssignedIdentities/federatedIdentityCredentials@2023-07-31-preview' = {
  parent: uamiCiCd
  name: '${uamiCiCdName}-federated-identity-credential'
  properties: {
    issuer: 'https://token.actions.githubusercontent.com'
    subject: 'repo:yotch0523/example-express-app:environment:production'
    audiences: [
      'api://AzureADTokenExchange'
    ]
  }
}

resource uamiSa 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-07-31-preview' = {
  name: uamiSaName
  location: location
  tags: tags
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-04-01' existing = {
  name: storageAccountName
}

resource roleAssignmentToUamiSa 'Microsoft.Authorization/roleAssignments@2021-04-01-preview' = {
  name: guid('contributor', uamiSaName, storageAccount.id)
  scope: storageAccount
  properties: {
    principalType: 'ServicePrincipal'
    roleDefinitionId: '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c'
    principalId: uamiSa.properties.principalId
  }
}
