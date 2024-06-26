using './main.bicep'

param location = 'japaneast'

param appServicePlanName = 'asp-example-express'
param webAppName = 'wa-example-express'
param storageAccountName = 'saexghcicd'
param uamiSaName = 'uami-sa'
param uamiCiCdName = 'uami-cicd'
param keyVaultName = 'kv-cicd'
param tags = {
  workload: 'r&d'
  environment: 'production'
}
