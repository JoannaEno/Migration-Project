targetScope = 'subscription'

//Sub export activity logs

@description('Required - Environment name to define the subscription location')
param env string

@description('Required - Workspace Resource ID ')
param Workspaceidaudit string

param Workspaceidoperation string

var activityLogDiagnosticSettingoperation = 'polaris-${env}-sub-activity-logs'
var activityLogDiagnosticSettingaudit = 'polaris-${env}-sub-activity-logs-security'

resource subscriptionActivityLogaudit 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if ((!empty(Workspaceidaudit))) {
  name: activityLogDiagnosticSettingaudit
  properties: {
    workspaceId: Workspaceidaudit
    logs: [
      {
        category: 'Administrative'
        enabled: true
      }
      {
        category: 'Security'
        enabled: true
      }
    ]
  }
}



resource subscriptionActivityLogoperation 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if ((!empty(Workspaceidoperation))) {
  name: activityLogDiagnosticSettingoperation
  properties: {
    workspaceId: Workspaceidoperation
    logs: [
      {
        category: 'Administrative'
        enabled: true
      }
      {
        category: 'Security'
        enabled: true
      }
      {
        category: 'ServiceHealth'
        enabled: true
      }
      {
        category: 'Alert'
        enabled: true
      }
      {
        category: 'Recommendation'
        enabled: true
      }
      {
        category: 'Policy'
        enabled: true
      }
      {
        category: 'Autoscale'
        enabled: true
      }
      {
        category: 'ResourceHealth'
        enabled: true
      }
    ]
  }
}
