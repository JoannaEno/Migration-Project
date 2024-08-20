targetScope = 'subscription'

// Parameters
param location string = 'uksouth'
param addressprefix string = '10.0.0.0/16'
param env string = 'bicep'
// param environment string = 'prod'

@description('The SKU of the Application Gateway.')
param skuName string = 'WAF_v2'

@description('The SKU Tier of the Application Gateway.')
param skuTier string = 'WAF_v2'

@description('Frontend ports Name for the Application Gateway.')
param frontendPortName string = 'appgwFrontEndPort'


@description('Backend address pool configuration for the Application Gateway.')
param backendAddressPoolName string = 'appGatewayBackendPool'


@description('HTTP settings configuration for the Application Gateway.')
param backendHttpSettingsName string ='appGatewayBackendHttpSettings'

@description('Autoscale configuration for the Application Gateway.')
// param autoscaleMaxCapacity int = 2
// param autoscaleMinCapacity int = 1
param skuCapacity int = 2




// Resource Group
resource resourcegroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'RG-Bicep'
  location: location
}

// Virtual Network
module vnetBicep './modules/Networking/virtualNetworks/vnet.bicep' = {
  name: 'vnetBicep'
  scope: resourceGroup(resourcegroup.name)
  params: {
    location: location
    name: 'vnet-${env}'
    addressPrefixes: [
      addressprefix
    ]
    subnets: [
      {
        name: 'appSubnet'
        addressPrefix: '10.0.1.0/24'
      }
      {
        name: 'dbSubnet'
        addressPrefix: '10.0.2.0/24'
      }
      {
        name: 'backendSubnet'
        addressPrefix: '10.0.3.0/24'
      }
    ]
  }
}

// Network Security Group
module nsgBicep './modules/customModules/nsg.bicep' = {
  name: 'nsgBicep'
  scope: resourceGroup(resourcegroup.name)
  params: {
    location: location
    name: 'nsg-${env}'
    securityRules: [
      {
        name: 'AllowHttpIn'
        priority: 100
        direction: 'Inbound'
        access: 'Allow'
        protocol: 'Tcp'
        sourcePortRange: '*'
        destinationPortRange: '80'
        sourceAddressPrefix: '*'
        destinationAddressPrefix: '*'
      }
      {
        name: 'AllowHttpsIn'
        priority: 101
        direction: 'Inbound'
        access: 'Allow'
        protocol: 'Tcp'
        sourcePortRange: '*'
        destinationPortRange: '443'
        sourceAddressPrefix: '*'
        destinationAddressPrefix: '*'
      }
    ]
  }
}

// Virtual Machine Scale Sets
module vmssBicep './modules/customModules/vmss.bicep' = {
    name: 'vmssModule'
    scope: resourceGroup(resourcegroup.name)
    params: {
      name: 'myVmss'
      location: location
      // managedIdentities: {
      //   systemAssigned : true
      // }
      orchestrationMode: 'Uniform'
      // upgradePolicyMode: 'Manual'
      vmNamePrefix: 'vmss'
      adminUsername: 'EnoAkan'
      adminPassword: 'EnoPassword123$'
      osType: 'Windows' // Set to Windows
      imagePublisher: 'MicrosoftWindowsDesktop'
      imageOffer: 'windows-11'
      imageSku: 'win11-23h2-pro'
      imageVersion: 'latest'
      subnetId: vnetBicep.outputs.subnetResourceIds[2]
      skuName: 'Standard_D2s_v3'
      skuCapacity: 2
    }
  }

//Public Ip for Application Gateway

module publicIP './modules/Networking/publicIPAddresses/publicip.bicep' = {
  name: 'appgwpublicIp'
  scope: resourceGroup(resourcegroup.name)
  params: {
    name: 'appGwPublicIP-${env}'
    location: location
    skuName: 'Standard'
    skuTier: 'Regional'
    publicIPAllocationMethod:'Static'
  }
}


// Application Gateway (WAF)
module appGatewayBicep './modules/customModules/appgw.bicep' = {
  name: 'appGatewayBicep'
  scope: resourceGroup(resourcegroup.name)
  params: {
    name: 'appGateway-${env}'
    location: location
    frontendIPConfigName: 'appGatewayFrontendIP'
    PublicIpId: publicIP.outputs.resourceId  
    frontendPortName: frontendPortName
    gatewayIPConfigName: 'appGatewayIPConfig'
    appgwSubnetId: vnetBicep.outputs.subnetResourceIds[0]
    backendAddressPoolName: backendAddressPoolName
    backendAddressPoolIp: '10.0.3.5'
    backendHttpSettingsName: backendHttpSettingsName
    httpListenerName: 'appGatewayHttpListener'
    requestRoutingRuleName: 'appGatewayRoutingRule'
    skuTier: skuTier
    skuName : skuName
    skuCapacity: skuCapacity
  }
  dependsOn: [
    vnetBicep,publicIP
  ]
}
// Azure Key Vault
module keyVaultBicep './modules/Security/Microsoft.KeyVault/vaults/deploy.bicep' = {
  name: 'keyVaultBicep'
  scope: resourceGroup(resourcegroup.name)
  params: {
    location: location
    name: 'joannaKv-${env}'
  }
}

// Recovery Services Vault
module recoveryVaultBicep './modules/recovery-services/vault/main.bicep' = {
  name: 'recoveryVaultBicep'
  scope: resourceGroup(resourcegroup.name)
  params: {
    location: location
    name: 'recoveryVault-${env}'
  }
}

// Storage Account (for Diagnostic Logs)
module storageAccountBicep './modules/Storage/storageAccounts/stg.bicep' = {
  name: 'storageAccountBicep'
  scope: resourceGroup(resourcegroup.name)
  params: {
    location: location
    name: 'joannastgdiaglogs${env}'
    storageAccountSku: 'Standard_LRS'
  }
}

// Azure Cosmos DB
module cosmosDbBicep './modules/customModules/cosmosdb.bicep' = {
  name: 'cosmosdbBicep'
  scope: resourceGroup(resourcegroup.name)
  params: {
    location: location
    kind: 'GlobalDocumentDB'
    cosmosDbAccountName: 'cosmosdbbicep'
  }
}

// Azure Database for MySQL Server
module mysqlServerBicep './modules/Microsoft.Sql/servers/deploy.bicep' = {
  name: 'mysqlServerBicep'
  scope: resourceGroup(resourcegroup.name)
  params: {
    location: location
    name: 'mysqlServer-${env}'
    administratorLogin: 'mysqlAdmin'
    administratorLoginPassword: 'P@ssw0rd!'
    databases: [
      {
        name: 'testsqldb'
        autoPauseDelay: -1
      }
    ]
    monthlylong: 'PT0S'
    weekylong: 'PT0S'
    yearlyRetention: 'PT0S'
  }
}

// Azure Monitor
// module monitorBicep './modules/Scripts/' = {
//   name: 'monitorBicep'
//   scope: rgBicep
//   params: {
//     location: location
//     workspaceName: 'logAnalyticsBicep'
//   }
// }
