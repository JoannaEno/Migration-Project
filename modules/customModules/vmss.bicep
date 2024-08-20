param name string
param location string 
param skuName string 
param skuCapacity int 
param adminUsername string
@secure()
param adminPassword string
param subnetId string
param imagePublisher string 
param imageOffer string 
param imageSku string 
param imageVersion string 
param vmNamePrefix string 
param orchestrationMode string 
param osType string 

resource vmss 'Microsoft.Compute/virtualMachineScaleSets@2023-09-01' = {
  name: name
  location: location
  sku: {
    name: skuName
    capacity: skuCapacity
    tier: 'Standard'
  }
  properties: {
    upgradePolicy: {
      mode: 'Manual'
    }
    orchestrationMode:orchestrationMode
    virtualMachineProfile: {
      storageProfile: {
        imageReference: {
          publisher: imagePublisher
          offer: imageOffer
          sku: imageSku
          version: imageVersion
        }
        osDisk: {
          createOption: 'FromImage'
          osType: osType
        }
      }
      osProfile: {
        adminUsername: adminUsername
        adminPassword: adminPassword
        computerNamePrefix: vmNamePrefix
      }
      networkProfile: {
        networkInterfaceConfigurations: [
          {
            name: 'nicConfig'
            properties: {
              primary: true
              ipConfigurations: [
                {
                  name: 'ipconfig'
                  properties: {
                    subnet: {
                      id: subnetId
                    }
                  }
                }
              ]
            }
          }
        ]
      }
    }
  }
}


// Output section to capture private IPs
