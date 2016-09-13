#This script will get all information required for the packer file

$subscription = Get-AzureRmSubscription
Write-Host 'Subscription Id :'  $subscription.SubscriptionId 
Write-Host 'TenantId : '  $subscription.TenantId
$appobj = Get-AzureRmADApplication -DisplayNameStartWith 'testdemo'
Write-Host 'Objectid' $appobj[0].ObjectId.ToString()
write-Host  'clientid' $appobj[0].ApplicationId.ToString()
write-Host  'clientsecret Refer AzureADSPNConfig.ps1' 
