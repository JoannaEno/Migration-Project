param name string
param location string
param gatewayIPConfigName string
param frontendIPConfigName string
// param frontendPortId string
param backendAddressPoolName string
param backendHttpSettingsName string
param httpListenerName string
param PublicIpId string
param requestRoutingRuleName string
param skuName string
param skuTier string
param skuCapacity int
param appgwSubnetId string
param frontendPortName string
param backendAddressPoolIp string


resource appGateway 'Microsoft.Network/applicationGateways@2021-08-01' = {
  name: name
  location: location
  properties: {
    sku: {
      name: skuName
      tier: skuTier
      capacity: skuCapacity
    }
    gatewayIPConfigurations: [
      {
        name: gatewayIPConfigName
        properties: {
          subnet: {
            id: appgwSubnetId // Replace with actual subnet ID
          }
        }
      }
    ]
    frontendIPConfigurations: [
      {
        name: frontendIPConfigName
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: PublicIpId // Replace with actual public IP ID
          }
        }
      }
    ]
    frontendPorts: [
      {
        name: frontendPortName
        properties: {
          port: 80 // Or other port number as needed
        }
      }
    ]
    backendAddressPools: [
      {
        name: backendAddressPoolName
        properties: {
          backendAddresses: [
            {
              ipAddress: backendAddressPoolIp // Replace with actual VMSS IP address or FQDN
            }
          ]
        }
      }
    ]
    backendHttpSettingsCollection: [
      {
        name: backendHttpSettingsName
        properties: {
          port: 80 // Or other port number as needed
          protocol: 'Http'
          cookieBasedAffinity: 'Disabled'
          pickHostNameFromBackendAddress: false
          requestTimeout: 20
        }
      }
    ]
    httpListeners: [
      {
        name: httpListenerName
        properties: {
          frontendIPConfiguration: {
            id: resourceId('Microsoft.Network/applicationGateways/frontendIPConfigurations', 'appGateway-bicep', 'appGatewayFrontendIP')
          }
          frontendPort: {
            id: resourceId('Microsoft.Network/applicationGateways/frontendPorts', 'appGateway-bicep', 'appgwFrontEndPort')
          }
          protocol: 'Http'
        }
      }
    ]
    requestRoutingRules: [
      {
        name: requestRoutingRuleName
        properties: {
          backendAddressPool: {
            id:  resourceId('Microsoft.Network/applicationGateways/backendAddressPools', 'appGateway-bicep', 'appGatewayBackendPool')
          }
          backendHttpSettings: {
            id: resourceId('Microsoft.Network/applicationGateways/backendHttpSettingsCollection', 'appGateway-bicep', 'appGatewayBackendHttpSettings')
          }
          httpListener: {
            id: resourceId('Microsoft.Network/applicationGateways/httpListeners', 'appGateway-bicep', 'appGatewayHttpListener')
          }
          ruleType: 'Basic'
          priority: 10
        }
      }
    ]
  }
}
