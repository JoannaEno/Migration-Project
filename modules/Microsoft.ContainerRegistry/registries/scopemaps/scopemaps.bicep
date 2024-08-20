
@description('Conditional. The name of the parent registry. Required if the template is used in a standalone deployment.')
param registryName string

@description('Required. The name of the scope map descrption')
param scopemapdescription string


@description('Required. The name of the scope map')
param scopemapname string


@description('Optional. The list of actions that trigger the webhook to post notifications.')
param action array = [
  'chart_delete'
  'chart_push'
  'delete'
  'push'
  'quarantine'
]


resource registry 'Microsoft.ContainerRegistry/registries@2023-06-01-preview' existing = {
  name: registryName
}


resource scopemapcreation 'Microsoft.ContainerRegistry/registries/scopeMaps@2023-01-01-preview' = {
  name: scopemapname
  parent: registry
  properties: {
    actions: action
    description: scopemapdescription
  }
}

/////////////
// Outputs //
/////////////


@description('The resource ID of the Azure container registry.')
output resourceId string = scopemapcreation.id

@description('The resource ID of the Azure container registry.')
output name string = scopemapcreation.name
