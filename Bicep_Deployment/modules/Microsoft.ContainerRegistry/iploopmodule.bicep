// param env string 
// param ukslocation string = 'uksouth'


// // Webapp check

// module ipoutput '../../modules/Microsoft.Web/sites/deploy.bicep' = {
//   name: '${uniqueString(deployment().name)}-test-wsfacom-uks'
//   params: {
//     vnetImagePull: false
//     kind: 'functionapp,linux' 
//     name: 'as-app-malwarescan-polaris-${env}-${ukslocation}'
//     serverFarmResourceId: 'as-plan-directus-polaris-test-uksouth' 
//   }
// }

// output ip array = array(ipoutput.outputs.outboundip)







// var outputip = [for item in ipoutput.outputs.outboundip : {
//   action: 'Allow'
//   value: item
//   } 
// ]
