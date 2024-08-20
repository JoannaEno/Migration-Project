@description('The location for resources in the UK South region.')
param ukslocation string = 'uksouth'

@description('The environment name.')
param env string = 'ah'

resource dataFactory 'Microsoft.DataFactory/factories@2018-06-01' = {
  name: 'adf-polaris-${env}-${ukslocation}'
  location: ukslocation
  properties: {

  }
}

resource integrationRuntime 'Microsoft.DataFactory/factories/integrationRuntimes@2018-06-01' = {
  name: 'AutoResolveIntegrationRuntime'
  parent: dataFactory
  properties: {
      type: 'Managed'
      typeProperties: {
        computeProperties: {
        location: 'AutoResolve'
          dataFlowProperties: {
              computeType: 'General'
              coreCount: 8
              timeToLive: 0
        }
    
         }
      }
      managedVirtualNetwork: {
        referenceName: 'default'
        type: 'ManagedVirtualNetworkReference'
      }
    }
  }

