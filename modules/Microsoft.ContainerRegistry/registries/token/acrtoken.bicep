@description('Conditional. The name of the parent registry. Required if the template is used in a standalone deployment.')
param registryName string

@description('Conditional. The name of the parent registry. Required if the template is used in a standalone deployment.')
param scopemapName string

param tokenname string = ''


resource registry 'Microsoft.ContainerRegistry/registries@2023-06-01-preview' existing = {
  name: registryName
}


resource token 'Microsoft.ContainerRegistry/registries/tokens@2023-01-01-preview' = {
  name: tokenname
  parent: registry
  properties: {
    credentials: {
      // certificates: [
      //   {
      //     encodedPemCertificate: 'string'
      //     expiry: 'string'
      //     name: 'string'
      //     thumbprint: 'string'
      //   }
      // ]
      // passwords: [
      //   {
      //     creationTime: '2023-11-24T14:37:22.5515941+00:00'
      //     name: 'password1'
      //   }
      //   {
      //     creationTime: '2023-11-24T14:38:55.4229573+00:00'
      //     name: 'password2'
      //   }
      //   {
      //     creationTime: '2023-11-24T14:37:22.5515941+00:00'
      //     name: 'password3'
      //   }
      // ]
    }
    scopeMapId: scopemapName
    status: 'enabled'
  }
}

output resourceid string = token.id



// output firstpwname string = token.properties.credentials.passwords[0].value


