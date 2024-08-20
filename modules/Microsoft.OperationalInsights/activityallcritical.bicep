param activitylogalerts_name string 
param scopesubscription string
param actionGroupId string 

resource activitylogalerts_critical_al 'microsoft.insights/activitylogalerts@2020-10-01' = {
  name: activitylogalerts_name
  location: 'global'
  properties: {
    scopes: [
      scopesubscription
    ]
    condition: {
      allOf: [
        {
          field: 'category'
          equals: 'ResourceHealth'
        }
        {
          field: 'properties.incidentType'
          equals: 'Incident'
        }
        {
          anyOf: [
            {
              field: 'properties.cause'
              equals: 'PlatformInitiated'
            }
            {
              field: 'properties.cause'
              equals: 'Unknown'
            }
          ]
        }
        {
          anyOf: [
            {
              field: 'properties.currentHealthStatus'
              equals: 'Degraded'
            }
            {
              field: 'properties.currentHealthStatus'
              equals: 'Unavailable'
            }
          ]
        }
        {
          anyOf: [
            {
              field: 'status'
              equals: 'Updated'
            }
          ]
        }
        {
          anyOf: [
            {
              field: 'properties.previousHealthStatus'
              equals: 'Unavailable'
            }
            {
              field: 'properties.previousHealthStatus'
              equals: 'Unknown'
            }
            {
              field: 'properties.previousHealthStatus'
              equals: 'Degraded'
            }
          ]
        }
        {
          anyOf: [
            // {
            //   field: 'resourceGroup'
            //   equals: 'cloud-shell-storage-westeurope'
            // }
            // {
            //   field: 'resourceGroup'
            //   equals: 'defaultresourcegroup-eus'
            // }
            // {
            //   field: 'resourceGroup'
            //   equals: 'defaultresourcegroup-suk'
            // }
            // {
            //   field: 'resourceGroup'
            //   equals: 'networkwatcherrg'
            // }
            {
              field: 'resourceGroup'
              equals: 'rg-adb2c'
            }
            {
              field: 'resourceGroup'
              equals: 'rg-automation'
            }
            {
              field: 'resourceGroup'
              equals: 'rg-directus'
            }
            {
              field: 'resourceGroup'
              equals: 'rg-directusstorage'
            }
            {
              field: 'resourceGroup'
              equals: 'rg-documentstorage'
            }
            {
              field: 'resourceGroup'
              equals: 'rg-malwarescanning'
            }
            {
              field: 'resourceGroup'
              equals: 'rg-privateendpoints'
            }
            {
              field: 'resourceGroup'
              equals: 'rg-rediscache'
            }
            {
              field: 'resourceGroup'
              equals: 'rg-springapps'
            }
            {
              field: 'resourceGroup'
              equals: 'rg-springapps-app-networking'
            }
            {
              field: 'resourceGroup'
              equals: 'rg-springapps-runtime-networking'
            }
            {
              field: 'resourceGroup'
              equals: 'rg-sqlserver'
            }
            {
              field: 'resourceGroup'
              equals: 'rg-staticwebapps'
            }
            {
              field: 'resourceGroup'
              equals: 'rg-virtual-networking'
            }
          ]
        }
      ]
    }
    actions: {
      actionGroups: [
        {
          actionGroupId: actionGroupId
          webhookProperties: {}
        }
      ]
     }
    enabled: true
  }
}
