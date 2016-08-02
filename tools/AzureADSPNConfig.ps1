#This script is put togeather after the painful process i went throught to do in UI. 

$displayName ='testdemo'
$homePage = 'http://devopspractice.com'
$identifierUri = 'http://devopspractice.com'
$password = 'hzkygExEcHe4xph38sdhOI37YB1GCzPoug0='



$azureAdApplication = New-AzureRmADApplication -DisplayName $displayName -HomePage $homePage -IdentifierUris $identifierUri -Password $password -Verbose
$appId = $azureAdApplication.ApplicationId
Write-Output "Azure AAD Application creation completed successfully (Application Id: $appId)" -Verbose

$spn = New-AzureRmADServicePrincipal -ApplicationId $appId
$spnName = $spn.ServicePrincipalName

Start-Sleep(20)
Connect-MsolService -Credential $cred
New-MsolServicePrincipalCredential -AppPrincipalId $appId -type Password -StartDate ([DateTime]::Now.AddMinutes(-5)) -EndDate ([DateTime]::Now.AddMonths(12)) -Value $password -Verbose

New-AzureRmRoleAssignment -RoleDefinitionName $spnRole -ServicePrincipalName $appId -Verbose

#Get all the existing ad applications
Get-AzureRmADApplication

#Cleanup actions enable below if you wanted to clean up the azure ad application
#$appobj | ForEach-Object { if ($_.ApplicationId.tostring().contains($appId)) { Remove-AzureRmADApplication -ApplicationObjectId $_.applicationobjectid -Force}}
