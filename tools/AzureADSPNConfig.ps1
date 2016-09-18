#This script is put togeather after the painful process i went throught to do in UI. 

$displayName ='testdemo'
$homePage = 'http://devopspractice.com'
$identifierUri = 'http://devopspractice.com'
$password = 'hzkygExEcHe4xph38sdhOI37YB1GCzPoug0='
$subscriptionid = 'xxxxxxx-xxxxx-xxxx-xxxx-xxxxxx' #refer the first script

################################################
#Step1: Check there is no existing AzureAD Application with the same Uri:
#Names are not unique, but the IdentifierUri should be unique
################################################

$clientApplication=Get-AzureRmADApplication -IdentifierUri $identifierUri
If ($clientApplication) {
  Write-Output "There is already an AD Application for this URI: $identifierUri"
  #Either remove, stop the process and rename the Uri, or get the ADApplication, which is the default behavior here: 
  #Remove-AzureRmADApplication -ObjectId $clientApplication.ObjectId -Force
}
else
{
  $clientApplication = New-AzureRmADApplication -DisplayName $displayName -HomePage $homePage -IdentifierUris $identifierUri -Password $password -Verbose
  Write-Output "A new AzureAD Application is created for this URI: $identifierUri"
}

################################################
#Step2: Create Application and SPN:
################################################
$clientId = $clientApplication.ApplicationId
Write-Output "Azure AAD Application creation completed successfully (Application Id: $clientId)" -Verbose

$spn = New-AzureRmADServicePrincipal -ApplicationId $clientId
$spnRole = "Contributor"

New-AzureRmRoleAssignment -RoleDefinitionName $spnRole -ServicePrincipalName $clientId -Verbose
################################################
#Step3: prepare credential data: 
################################################
#copy $clientId and $password parameters to another place
#use $clientId as username and $password as password

Write-Output "Username: $clientId"
Write-Output "Password: $password"

################################################
#Step4: Login to verify the SPN  
################################################

$creds=Get-Credential   
#Use the subscriptionId parameter from loginazuresubscription script.
$tenantId= (Get-AzureRmSubscription -SubscriptionId $subscriptionid).TenantId

#Now we can login and verify our new spn:
Login-AzureRmAccount -Credential $creds -ServicePrincipal -TenantId $tenantId

$objectId=$spn.Id


#Cleanup actions enable below if you wanted to clean up the azure ad application
#$clientApplication |  Remove-AzureRmADApplication -ObjectId $_.ObjectId -Force 


################################################
#Step5: Get the packer info 
################################################

Write-Host 'subscription_Id :'  $subscriptionid.tostring()
Write-Host 'tenant_Id : '  $tenantId.ToString()
Write-Host 'object_id :' $objectId.ToString()
write-Host 'client_id :' $clientId.ToString()
write-Host 'client_secret : ' $password.ToString() 
