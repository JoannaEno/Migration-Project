// ================ //
// Parameters       //
// ================ //
@description('Conditional. The name of the parent site resource. Required if the template is used in a standalone deployment.')
param appName string

@description('Required. Type of site to deploy.')
@allowed([
  'functionapp' // function app windows os
  'functionapp,linux' // function app linux os
  'functionapp,workflowapp' // logic app workflow
  'functionapp,workflowapp,linux' // logic app docker container
  'app' // normal web app
])
param kind string

@description('Optional. Required if app of kind functionapp. Resource ID of the storage account to manage triggers and logging function executions.')
param storageAccountId string = ''

@description('Optional. Resource ID of the app insight to leverage for this resource.')
param appInsightId string = ''

@description('Optional. For function apps. If true the app settings "AzureWebJobsDashboard" will be set. If false not. In case you use Application Insights it can make sense to not set it for performance reasons.')
param setAzureWebJobsDashboard bool = contains(kind, 'functionapp') ? true : false

@description('Optional. The app settings key-value pairs except for AzureWebJobsStorage, AzureWebJobsDashboard, APPINSIGHTS_INSTRUMENTATIONKEY and APPLICATIONINSIGHTS_CONNECTION_STRING.')
param appSettingsKeyValuePairsfunction object = {}

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

param stgaccess string = ''

param stgfunctionname string = ''



// =========== //
// Variables   //
// =========== //
var azureWebJobsValues = !empty(storageAccountId) ? union({
    AzureWebJobsStorage: 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};AccountKey=${storageAccount.listKeys().keys[0].value};EndpointSuffix=core.windows.net'
  }, ((setAzureWebJobsDashboard == true) ? {
    AzureWebJobsDashboard: 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};AccountKey=${storageAccount.listKeys().keys[0].value}'
  } : {})) : {}

var appInsightsValues = !empty(appInsightId) ? {
  APPINSIGHTS_INSTRUMENTATIONKEY: appInsight.properties.InstrumentationKey
  APPLICATIONINSIGHTS_CONNECTION_STRING: appInsight.properties.ConnectionString
} : {}

var expandedAppSettingsfunction = union(appSettingsKeyValuePairsfunction, azureWebJobsValues, appInsightsValues)
// param resourcegroup string
// =========== //
// Existing resources //
// =========== //
resource app 'Microsoft.Web/sites@2020-12-01' existing = {
  name: appName
}

resource appInsight 'Microsoft.Insights/components@2020-02-02' existing = if (!empty(appInsightId)) {
  name: last(split(appInsightId, '/'))!
  scope: resourceGroup(split(appInsightId, '/')[2], split(appInsightId, '/')[4])
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-02-01' existing = if (!empty(storageAccountId)) {
  name: storageAccountId
}

// =========== //
// Deployments //
// =========== //
resource defaultTelemetry 'Microsoft.Resources/deployments@2021-04-01' = if (enableDefaultTelemetry) {
  name: 'pid-47ed15a6-730a-4827-bcb4-0fd963ffbd82-${uniqueString(deployment().name)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
}

resource appSettings 'Microsoft.Web/sites/config@2020-12-01' = {
  name: 'appsettings'
  kind: kind
  parent: app
  properties: expandedAppSettingsfunction
  
}

resource stgconfig 'Microsoft.Web/sites/config@2022-03-01' =  if (!empty(stgfunctionname)) {
  name: 'azurestorageaccounts'
  kind: kind
  parent: app
    properties: {
    webjobhostsconfiguration: {
        type: 'AzureFiles'
        accountName: stgfunctionname
        shareName: 'azure-webjobs-hosts'
        mountPath: '/webjob/azure-webjobs-hosts'
        accessKey: stgaccess
      }
      webjobhostssecrets: {
        type: 'AzureFiles'
        accountName: stgfunctionname
        shareName: 'uploads'
        mountPath: '/webjob/azure-webjobs-secrets'
        accessKey: stgaccess
    }

  } 
}





resource autoheal 'Microsoft.Web/sites/config@2022-03-01' = {
  name: 'web'
  kind: kind
  parent: app
    properties: {
      autoHealEnabled: true
      autoHealRules: {
        actions: {
          actionType: 'Recycle'
          minProcessExecutionTime: '00:00:00'
        }
        triggers: {
          requests: {
            count: 100
            timeInterval: '00:01:00'
          }
          privateBytesInKB: 0
          statusCodes: []
          slowRequestsWithPath: []
          statusCodesRange: []
        }

      }
  } 
}


// =========== //
// Outputs     //
// =========== //
@description('The name of the site config.')
output name string = appSettings.name

@description('The resource ID of the site config.')
output resourceId string = appSettings.id

@description('The resource group the site config was deployed into.')
output resourceGroupName string = resourceGroup().name
