param appServicePlanName string
param webAppName string
param location string = 'japaneast'
param tags object = {}

resource appServicePlan 'Microsoft.Web/serverfarms@2023-12-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: 'F1'
    tier: 'Free'
    size: 'F1'
    family: 'F'
    capacity: 0
  }
  kind: 'app'
  properties: {
    perSiteScaling: false
    elasticScaleEnabled: false
    maximumElasticWorkerCount: 1
    isSpot: false
    reserved: false
    isXenon: false
    hyperV: false
    targetWorkerCount: 0
    targetWorkerSizeId: 0
    zoneRedundant: false
  }
  tags: tags
}

resource webApp 'Microsoft.Web/sites@2023-12-01' = {
  name: webAppName
  location: 'Japan East'
  kind: 'webapp'
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '/subscriptions/${subscription().subscriptionId}/resourcegroups/rg-ghcicd/providers/Microsoft.ManagedIdentity/userAssignedIdentities/uami-sa': {}
    }
  }
  tags: tags
  properties: {
    enabled: true
    hostNameSslStates: [
      {
        name: '${webAppName}.azurewebsites.net'
        sslState: 'Disabled'
        hostType: 'Standard'
      }
      {
        name: '${webAppName}.scm.azurewebsites.net'
        sslState: 'Disabled'
        hostType: 'Repository'
      }
    ]
    serverFarmId: appServicePlan.id
    reserved: false
    isXenon: false
    hyperV: false
    dnsConfiguration: {}
    vnetRouteAllEnabled: false
    vnetImagePullEnabled: false
    vnetContentShareEnabled: false
    siteConfig: {
      numberOfWorkers: 1
      acrUseManagedIdentityCreds: false
      alwaysOn: false
      http20Enabled: false
      functionAppScaleLimit: 0
      minimumElasticInstanceCount: 1
    }
    scmSiteAlsoStopped: false
    clientAffinityEnabled: false
    clientCertEnabled: false
    clientCertMode: 'Required'
    hostNamesDisabled: false
    vnetBackupRestoreEnabled: false
    customDomainVerificationId: '2D417DA10028355959CBAED377C9E97B38A61FECFCE41A63C1DF66253389D285'
    containerSize: 0
    dailyMemoryTimeQuota: 0
    httpsOnly: true
    redundancyMode: 'None'
    storageAccountRequired: false
    keyVaultReferenceIdentity: 'SystemAssigned'
  }
}

resource webApp_ftp 'Microsoft.Web/sites/basicPublishingCredentialsPolicies@2023-12-01' = {
  parent: webApp
  name: 'ftp'
  properties: {
    allow: true
  }
}

resource webApp_scm 'Microsoft.Web/sites/basicPublishingCredentialsPolicies@2023-12-01' = {
  parent: webApp
  name: 'scm'
  properties: {
    allow: true
  }
}

resource webApp_web 'Microsoft.Web/sites/config@2023-12-01' = {
  parent: webApp
  name: 'web'
  properties: {
    numberOfWorkers: 1
    defaultDocuments: [
      'Default.htm'
      'Default.html'
      'Default.asp'
      'index.htm'
      'index.html'
      'iisstart.htm'
      'default.aspx'
      'index.php'
      'hostingstart.html'
    ]
    netFrameworkVersion: 'v4.0'
    phpVersion: '5.6'
    nodeVersion: '~20'
    requestTracingEnabled: false
    remoteDebuggingEnabled: false
    remoteDebuggingVersion: 'VS2019'
    httpLoggingEnabled: true
    acrUseManagedIdentityCreds: false
    logsDirectorySizeLimit: 100
    detailedErrorLoggingEnabled: false
    publishingUsername: webAppName
    scmType: 'GitHubAction'
    use32BitWorkerProcess: true
    webSocketsEnabled: false
    alwaysOn: false
    appCommandLine: 'node ./dist/'
    managedPipelineMode: 'Integrated'
    virtualApplications: [
      {
        virtualPath: '/'
        physicalPath: 'site\\wwwroot'
        preloadEnabled: false
      }
    ]
    loadBalancing: 'LeastRequests'
    experiments: {
      rampUpRules: []
    }
    autoHealEnabled: false
    vnetRouteAllEnabled: false
    vnetPrivatePortsCount: 0
    localMySqlEnabled: false
    xManagedServiceIdentityId: 17171
    ipSecurityRestrictions: [
      {
        ipAddress: 'Any'
        action: 'Allow'
        priority: 2147483647
        name: 'Allow all'
        description: 'Allow all access'
      }
    ]
    scmIpSecurityRestrictions: [
      {
        ipAddress: 'Any'
        action: 'Allow'
        priority: 2147483647
        name: 'Allow all'
        description: 'Allow all access'
      }
    ]
    scmIpSecurityRestrictionsUseMain: false
    http20Enabled: false
    minTlsVersion: '1.2'
    scmMinTlsVersion: '1.2'
    ftpsState: 'FtpsOnly'
    preWarmedInstanceCount: 0
    elasticWebAppScaleLimit: 0
    functionsRuntimeScaleMonitoringEnabled: false
    minimumElasticInstanceCount: 1
    azureStorageAccounts: {}
  }
}

resource webApp_azurewebsites_net 'Microsoft.Web/sites/hostNameBindings@2023-12-01' = {
  parent: webApp
  name: '${webAppName}.azurewebsites.net'
  properties: {
    siteName: webAppName
    hostNameType: 'Verified'
  }
}

output webAppId string = webApp.id
