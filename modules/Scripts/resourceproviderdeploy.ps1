# Variables

#Test subscription used as the source for resource providers used.
$sourcesubscriptionId = "f00e932c-2dc9-4eed-83ab-28bee4d9dbb3"

#Current Target to replicate resource providers to(Training)
$targetsubscriptionId = "28949f95-bda6-4716-a7f7-3b13b40d1301"

#Gets all the resource providers for the source subscription
$sourceResourceproviders = az provider list --subscription $sourcesubscriptionId --query "[].namespace" --output tsv

#Register each resource provider from the source in to the target subscription
foreach ($resourceProvider in $sourceResourceproviders) {
    az provider register --namespace $resourceProvider --subscription $targetsubscriptionId
}

#Checks the status of the registration process (waits until all the providers are registered)
$registrationStatus = "Registering"

while ($registrationStatus -eq "Registering") {
    $registrationStatus = az provider list --subscription $targetsubscriptionId --query "[?registrationState!='Registered'].{State:registrationState}" --output tsv
    if ($registrationStatus -eq $null){
        Write-Host "All resource providers registered successfully in the target subscription"
    } else {
        Write-Host "Waiting for resource providers to be registered. Current status: $registrationStatus"
    }
}