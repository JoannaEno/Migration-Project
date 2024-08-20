@description('Required. The name of the database.')
param name string

@description('Conditional. The name of the parent SQL Server. Required if the template is used in a standalone deployment.')
param serverName string

@description('Optional. The collation of the database.')
param collation string = 'SQL_Latin1_General_CP1_CI_AS'

@description('Optional. The skuTier or edition of the particular SKU.')
param skuTier string = 'GeneralPurpose'

@description('Optional. The name of the SKU.')
param skuName string = 'GP_S_Gen5'

@description('Optional. Capacity of the particular SKU.')
param skuCapacity int 

@description('Optional. If the service has different generations of hardware, for the same SKU, then that can be captured here.')
param skuFamily string = 'Gen5'

@description('Optional. Size of the particular SKU.')
param skuSize string = ''

@description('Optional. The max size of the database expressed in bytes.')
param maxSizeBytes int = 34359738368

@description('Optional. The name of the sample schema to apply when creating this database.')
param sampleName string = ''

@description('(Prod=True UAT/DEV/TEST= False )Optional. Whether or not this database is zone redundant.')
param zoneRedundant bool 

@description('Optional. The license type to apply for this database.')
param licenseType string = 'LicenseIncluded'

@description('Optional. The state of read-only routing.')
@allowed([
  'Enabled'
  'Disabled'
])
param readScale string = 'Disabled'

@description('Optional. The number of readonly secondary replicas associated with the database.')
param highAvailabilityReplicaCount int = 0

@description('Optional. Minimal capacity that database will always have allocated.')
param minCapacity string = '0.5'

@description('(UAT/DEV/Test = 60)Optional. Time in minutes after which database is automatically paused. A value of -1 means that automatic pause is disabled.')
param autoPauseDelay int 

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Optional. The resource ID of the elastic pool containing this database.')
param elasticPoolId string = ''

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Weekly retention period for databasebackup.NOTE- PT0S format')
param weekylong string //= 'PT0S'

@description('Optional. Monthly retention period for databasebackup.NOTE- PT0S format')
param monthlylong string //= 'PT0S'

@description('Optional. Yearly retention period for databasebackup.NOTE- PT0S format')
param yearlyRetention string //= 'PT0S'

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

@description('Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely.')
@minValue(0)
@maxValue(365)
param diagnosticLogsRetentionInDays int = 365

@description('Optional. Resource ID of the diagnostic storage account.')
param diagnosticStorageAccountId string = ''

@description('Optional. Resource ID of the diagnostic log analytics workspace.')
param diagnosticWorkspaceId string //= ''

@description('Optional. Resource ID of the diagnostic log analytics workspace.')
param diagnosticWorkspaceIdaudit string //= ''

@description('Optional. Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.')
param diagnosticEventHubAuthorizationRuleId string = ''

@description('Optional. Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category.')
param diagnosticEventHubName string = ''

// @description('Optional. The name of logs that will be streamed. "allLogs" includes all possible logs for the resource.')
// @allowed([
//   'allLogs'
//   'SQLInsights'
//   'AutomaticTuning'
//   'QueryStoreRuntimeStatistics'
//   'QueryStoreWaitStatistics'
//   'Errors'
//   'DatabaseWaitStatistics'
//   'Timeouts'
//   'Blocks'
//   'Deadlocks'
//   'DevOpsOperationsAudit'
//   'SQLSecurityAuditEvents'
// ])
// param diagnosticLogCategoriesToEnable array = [
//   'allLogs'
// ]

// @description('Optional. The name of metrics that will be streamed.')
// @allowed([
//   'Basic'
//   'InstanceAndAppAdvanced'
//   'WorkloadManagement'
// ])
// param diagnosticMetricsToEnable array = [
//   'Basic'
//   'InstanceAndAppAdvanced'
//   'WorkloadManagement'
// ]

@description('Optional. The name of the diagnostic setting, if deployed.')
param diagnosticSettingsName string = '${name}-diagnosticSettings'

@description('Optional. The name of the diagnostic setting, if deployed.')
param diagnosticSettingsNameAudit string = '${name}-Audit-diagnosticSettings'

// var diagnosticsLogsSpecified = [for category in filter(diagnosticLogCategoriesToEnable, item => item != 'allLogs'): {
//   category: category
//   enabled: true
//   retentionPolicy: {
//     enabled: true
//     days: diagnosticLogsRetentionInDays
//   }
// }]

// var diagnosticsLogs = contains(diagnosticLogCategoriesToEnable, 'allLogs') ? [
//   {
//     categoryGroup: 'allLogs'
//     enabled: true
//     retentionPolicy: {
//       enabled: true
//       days: diagnosticLogsRetentionInDays
//     }
//   }
// ] : diagnosticsLogsSpecified

// var diagnosticsMetrics = [for metric in diagnosticMetricsToEnable: {
//   category: metric
//   timeGrain: null
//   enabled: true
//   retentionPolicy: {
//     enabled: true
//     days: diagnosticLogsRetentionInDays
//   }
// }]

@description('Optional. The storage account type to be used to store backups for this database.')
@allowed([
  'Geo'
  'Local'
  'Zone'
  ''
])
param requestedBackupStorageRedundancy string 

@description('Optional. Whether or not this database is a ledger database, which means all tables in the database are ledger tables. Note: the value of this property cannot be changed after the database has been created.')
param isLedgerOn bool = false

@description('Optional. Maintenance configuration ID assigned to the database. This configuration defines the period when the maintenance updates will occur.')
param maintenanceConfigurationId string 

// The SKU object must be built in a variable
// The alternative, 'null' as default values, leads to non-terminating deployments
var skuVar = union({
    name: skuName
    tier: skuTier
  }, (skuCapacity != -1) ? {
    capacity: skuCapacity
  } : !empty(skuFamily) ? {
    family: skuFamily
  } : !empty(skuSize) ? {
    size: skuSize
  } : {})

resource defaultTelemetry 'Microsoft.Resources/deployments@2021-04-01' = if (enableDefaultTelemetry) {
  name: 'pid-47ed15a6-730a-4827-bcb4-0fd963ffbd82-${uniqueString(deployment().name, location)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
}

resource server 'Microsoft.Sql/servers@2021-11-01' existing = {
  name: serverName
}

resource database 'Microsoft.Sql/servers/databases@2021-11-01' = {
  name: name
  parent: server
  location: location
  tags: tags
  properties: {
    collation: collation
    maxSizeBytes: maxSizeBytes
    sampleName: sampleName
    zoneRedundant: zoneRedundant
    licenseType: licenseType
    readScale: readScale
    minCapacity: !empty(minCapacity) ? json(minCapacity): '0.5' // The json() function is used to allow specifying a decimal value.
    autoPauseDelay: autoPauseDelay
    highAvailabilityReplicaCount: highAvailabilityReplicaCount
    requestedBackupStorageRedundancy: any(requestedBackupStorageRedundancy)
    isLedgerOn: isLedgerOn
    maintenanceConfigurationId: !empty(maintenanceConfigurationId) ? maintenanceConfigurationId : null
    elasticPoolId: elasticPoolId
  }
  sku: skuVar
}

// Short term backup retention 

resource backupshortterm_database 'Microsoft.Sql/servers/databases/backupShortTermRetentionPolicies@2022-05-01-preview' = {
  parent: database
  name: 'default'
  properties: {
    retentionDays: 31
    diffBackupIntervalInHours: 12
  }
}

// Long ter backup retention // PT0S
resource backuplongterm_database 'Microsoft.Sql/servers/databases/backupLongTermRetentionPolicies@2022-05-01-preview' = {
  name: 'default'
  parent: database
  properties: {
    monthlyRetention: monthlylong 
    weeklyRetention: weekylong
    yearlyRetention: yearlyRetention
     weekOfYear: 1
    
  }
}



resource database_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if ((!empty(diagnosticStorageAccountId)) || (!empty(diagnosticWorkspaceId)) || (!empty(diagnosticEventHubAuthorizationRuleId)) || (!empty(diagnosticEventHubName))) {
  name: diagnosticSettingsName
  properties: {
    storageAccountId: !empty(diagnosticStorageAccountId) ? diagnosticStorageAccountId : null
    workspaceId: !empty(diagnosticWorkspaceId) ? diagnosticWorkspaceId : null
    eventHubAuthorizationRuleId: !empty(diagnosticEventHubAuthorizationRuleId) ? diagnosticEventHubAuthorizationRuleId : null
    eventHubName: !empty(diagnosticEventHubName) ? diagnosticEventHubName : null
    metrics: [
      {
        enabled: true
        category: 'Basic'
      }
      {
        enabled: true
        category: 'InstanceAndAppAdvanced'
      }
      {
        enabled: true
        category: 'WorkloadManagement'
      }
    ]
    logs: [
      {
        category: 'SQLInsights'
        enabled: true
        retentionPolicy: {
          days: diagnosticLogsRetentionInDays
          enabled: false
        }
      }
      {
        category: 'AutomaticTuning'
        enabled: true
        retentionPolicy: {
          days: diagnosticLogsRetentionInDays
          enabled: false
        }
      }
      {
        category: 'QueryStoreRuntimeStatistics'
        enabled: true
        retentionPolicy: {
          days: diagnosticLogsRetentionInDays
          enabled: false
        }
      }
      {
        category: 'QueryStoreWaitStatistics'
        enabled: true
        retentionPolicy: {
          days: diagnosticLogsRetentionInDays
          enabled: false
        }
      }
      {
        category: 'Errors'
        enabled: true
        retentionPolicy: {
          days: diagnosticLogsRetentionInDays
          enabled: false
        }
      }
      {
        category: 'DatabaseWaitStatistics'
        enabled: true
        retentionPolicy: {
          days: diagnosticLogsRetentionInDays
          enabled: false
        }
      }
      {
        category: 'Timeouts'
        enabled: true
        retentionPolicy: {
          days: diagnosticLogsRetentionInDays
          enabled: false
        }
      }
      {
        category: 'Blocks'
        enabled: true
        retentionPolicy: {
          days: diagnosticLogsRetentionInDays
          enabled: false
        }       
      }
      {
        category: 'Deadlocks'
        enabled: true
        retentionPolicy: {
          days: diagnosticLogsRetentionInDays
          enabled: false
        }       
      }
    ] 

  }
  scope: database
}

resource database_diagnosticSettingsaudit 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if ((!empty(diagnosticStorageAccountId)) || (!empty(diagnosticWorkspaceIdaudit)) || (!empty(diagnosticEventHubAuthorizationRuleId)) || (!empty(diagnosticEventHubName))) {
  name: diagnosticSettingsNameAudit
  properties: {
    storageAccountId: !empty(diagnosticStorageAccountId) ? diagnosticStorageAccountId : null
    workspaceId: !empty(diagnosticWorkspaceIdaudit) ? diagnosticWorkspaceIdaudit : null
    eventHubAuthorizationRuleId: !empty(diagnosticEventHubAuthorizationRuleId) ? diagnosticEventHubAuthorizationRuleId : null
    eventHubName: !empty(diagnosticEventHubName) ? diagnosticEventHubName : null
    // metrics: diagnosticsMetrics
    logs: [
      {
        categoryGroup: 'audit' 
        enabled: true
        retentionPolicy: {
          days: 30
          enabled: false
        }
      }
    ] 

  }
  scope: database
}



@description('The name of the deployed database.')
output name string = database.name

@description('The resource ID of the deployed database.')
output databaseresourceId string = database.id

@description('The resource group of the deployed database.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = database.location
