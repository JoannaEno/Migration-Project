param utcValue string = utcNow()
param location string = resourceGroup().location
param ps1location string = loadTextContent('../Application.platform/stopspring.ps1')

resource runPowerShellInlineWithOutput 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
  name: 'runPowerShellInlineWithOutput'
  location: location
  kind: 'AzurePowerShell'
  properties: {
    forceUpdateTag: utcValue
    azPowerShellVersion: '8.3'
    scriptContent: '''
    param([string] $ps1location)
    New-Item -Path . -Name "runbook.ps1" -ItemType "file" -Value \'${ps1location}\'
    $automationAccountName = "automation-polaris-test-uksouth" 
    $runbookName = "TestRunbook"

    Import-AzAutomationRunbook -Path runbook.ps1 -Tags $Tags -ResourceGroupName "rg-automation" -AutomationAccountName $automationAccountName -Type Powershell
    Publish-AzAutomationRunbook -AutomationAccountName $automationAccountName -Name $runbookName -ResourceGroupName "rg-automation"
        '''
    arguments: '-value \'${ps1location}\''
    timeout: 'PT1H'
    cleanupPreference: 'OnSuccess'
    retentionInterval: 'P1D'
  }
}

// Import-AzAutomationRunbook –AutomationAccountName $automationAccountName –Name $runbookName –Path 'runbook.ps1' -Overwrite
// scriptContent: loadTextContent('../scripts/Invoke-AzResourceStateCheck.ps1')
// arguments: '-azResourceResourceId \'${parAzResourceId}\' -apiVersion \'${parAzResourceApiVersion}\' -azResourcePropertyToCheck \'${parAzResourcePropertyToCheck}\' -azResourceDesiredState \'${parAzResourceDesiredState}\' -waitInSecondsBetweenIterations \'${parWaitInSecondsBetweenIterations}\' -maxIterations \'${parMaxIterations}\''
// cleanupPreference: 'OnSuccess'


// Publish-AzureAutomationRunbook –AutomationAccountName $automationAccountName –Name $runbookName

// $params = @{
//   AutomationAccountName = 'automation-polaris-test-uksouth'
//   Name                  = 'TestRunbook'
//   ResourceGroupName     = 'rg-automation'
//   Type                  = 'PowerShell'
//   Path                  = '\modules\Application.platform\stopspring.ps1'
// }
// Import-AzAutomationRunbook @params

// Below works
// param name string = '\\"John Dole\\"'
// param utcValue string = utcNow()
// param location string = resourceGroup().location

// resource runPowerShellInlineWithOutput 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
//   name: 'runPowerShellInlineWithOutput'
//   location: location
//   kind: 'AzurePowerShell'
//   properties: {
//     forceUpdateTag: utcValue
//     azPowerShellVersion: '8.3'
//     scriptContent: '''
//       param([string] $name)
//       $output = "Hello {0}" -f $name
//       Write-Output $output
//       $DeploymentScriptOutputs = @{}
//       $DeploymentScriptOutputs["text"] = $output
//     '''
//     arguments: '-name ${name}'
//     timeout: 'PT1H'
//     cleanupPreference: 'OnSuccess'
//     retentionInterval: 'P1D'
//   }
// }

// output result string = runPowerShellInlineWithOutput.properties.outputs.text




// param utcValue string = utcNow()
// param location string = resourceGroup().location

// resource runPowerShellInlineWithOutput 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
//   name: 'runPowerShellInlineWithOutput'
//   location: location
//   kind: 'AzurePowerShell'
//   properties: {
//     forceUpdateTag: utcValue
//     azPowerShellVersion: '8.3'
//     scriptContent: '''
//     Get-AzSpringCloud -Name "spring-polaris-test-uksouth" -ResourceGroupName "rg-springapps" -SubscriptionId "f00e932c-2dc9-4eed-83ab-28bee4d9dbb3"
//     '''
//     retentionInterval: 'P1D'
//   }
// }

// output result string = runPowerShellInlineWithOutput.properties.outputs.text



// $automationAccountName = "automation-polaris-test-uksouth" 
// $runbookName = "TestRunbook"
// $scriptPath = "..\modules\Application.platform\stopspring.ps1"
// Set-AzureAutomationRunbookDefinition –AutomationAccountName $automationAccountName –Name $runbookName –Path $ scriptPath -Overwrite
// Publish-AzureAutomationRunbook –AutomationAccountName $automationAccountName –Name $runbookName
