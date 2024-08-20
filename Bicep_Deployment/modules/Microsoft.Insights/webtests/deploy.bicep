

@sys.description('Required. Name of the webtest.')
param name string

@sys.description('Required. Resource ID of the App Insights resource to link with this webtest.')
param appInsightResourceId string

@sys.description('Required. User defined name if this WebTest.')
param webTestName string

// @sys.description('Optional. Resource tags. Note: a mandatory tag \'hidden-link\' based on the \'appInsightResourceId\' parameter will be automatically added to the tags defined here.')
// param tags object?

// @sys.description('Required. Url location to test.')
// param requesturl string


@sys.description('Optional. Unique ID of this WebTest.')
param syntheticMonitorId string = name

@sys.description('Optional. Location for all Resources.')
param location string 

@sys.description('Required. The collection of request properties.')
param request object

@sys.description('Optional. User defined description for this WebTest.')
param description string = ''


@sys.description('Optional. The kind of WebTest that this web test watches.')
@allowed([
  'multistep'
  'ping'
  'standard'
])
param kind string = 'standard'

@sys.description('Optional. List of where to physically run the tests from to give global coverage for accessibility of your application.')
param locations array = [
  {
    Id: 'emea-se-sto-edge' // Location from where the test is run- UK west
  }
  {
    Id: 'emea-ru-msa-edge' // Location from where the test is run- UK south
  }
]

@sys.description('Optional. Is the test actively being monitored.')
param enabled bool = true

@sys.description('Optional. Interval in seconds between test runs for this WebTest.')
param frequency int

@sys.description('Optional. Seconds until this WebTest will timeout and fail.')
param timeout int

@sys.description('Optional. Allow for retries should this WebTest fail.')
param retryEnabled bool = true

// @sys.description('Optional. The collection of validation rule properties.')
// param validationRules object = {}

// @sys.description('Optional. An XML configuration specification for a WebTest.')
// param configuration object = {}


@sys.description('Optional. Array of role assignments to create.')
param roleAssignments array = []

@sys.description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

var hiddenLinkTag = {
  'hidden-link:${appInsightResourceId}': 'Resource'
}

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


resource webtest 'Microsoft.Insights/webtests@2022-06-15' = {
  name: name
  location: location
  tags: hiddenLinkTag
  properties: {
    Kind: kind
    Locations: locations
    Name: webTestName
    Description: description
    SyntheticMonitorId: syntheticMonitorId
    Enabled: enabled
    Frequency: frequency
    Timeout: timeout
    RetryEnabled: retryEnabled
    Request: request
    // {
    //   RequestUrl: requesturl
    //   Headers: null
    //   HttpVerb: 'GET'
    //   RequestBody: null
    //   ParseDependentRequests: false
    //   FollowRedirects: null
    // }
    ValidationRules: {
      ExpectedHttpStatusCode: 200
      IgnoreHttpStatusCode: false
      ContentValidation: null
      SSLCheck: false
      SSLCertRemainingLifetimeCheck: null
    }
    Configuration: null
  }
}


module webTests_roleAssignments '.bicep/nested_roleAssignments.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name, location)}-WebTests-Rbac-${index}'
  params: {
    description: contains(roleAssignment, 'description') ? roleAssignment.description : ''
    principalIds: roleAssignment.principalIds
    principalType: contains(roleAssignment, 'principalType') ? roleAssignment.principalType : ''
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    condition: contains(roleAssignment, 'condition') ? roleAssignment.condition : ''
    delegatedManagedIdentityResourceId: contains(roleAssignment, 'delegatedManagedIdentityResourceId') ? roleAssignment.delegatedManagedIdentityResourceId : ''
    resourceId: webtest.id
  }
}]


@sys.description('The name of the webtest.')
output name string = webtest.name

@sys.description('The resource ID of the webtest.')
output resourceId string = webtest.id

@sys.description('The resource group the resource was deployed into.')
output resourceGroupName string = resourceGroup().name

@sys.description('The location the resource was deployed into.')
output location string = webtest.location
