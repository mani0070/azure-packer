$location = 'North Europe'
##########################################
#Step0: Collect the data: 
##########################################
$destinationStorageAccountName = 'destinationsa'
$destinationContainerName='vhds'
$destinationblobName= 'osdiskforwindowssimple.vhd'
$destinationResourceGroupName = 'demo'

$sourceStorageAccountName='sourcesa'
$sourceContainerName='system'
$sourceblobName= 'Microsoft.Compute/Images/images/packer-osDisk.d68f764c3351-xxxx-xxxx-xxxx-d68f764c3351.vhd'
$sourceStorageAccountResourceGroup='demo2'

<#Sample output:
#$customimagebloburi='https://<storageAccount>.blob.core.windows.net/system/Microsoft.Compute/Images/images/packer-osDisk.63c7e823-xxxx-xxxx-xxxx-d68f764c3351.vhd
?se=2016-10-20T02%3A17%3A57Z&sig=2UgHgkeEwbOsn%2BdoExxxxsLszFY8hk7ODITZ2lpxxxx0qU%3D&sp=r&sr=b&sv=2015-02-21'
#>

$destinationStorageContext = New-AzureStorageContext -StorageAccountName $destinationStorageAccountName -StorageAccountKey (Get-AzureRmStorageAccountKey -ResourceGroupName $destinationResourceGroupName -Name $destinationStorageAccountName).Value[0] 

$sourceStorageContext= New-AzureStorageContext -StorageAccountName $sourcestorageAccountName -StorageAccountKey (Get-AzureRmStorageAccountKey -ResourceGroupName $sourceStorageAccountResourceGroup -Name $sourcestorageAccountName).Value[0] 

Set-AzureStorageContainerAcl -Name $destinationContainerName -Permission Blob -Context $destinationStorageContext

#nuget install WindowsAzure.Storage
$destinationKeys=(Get-AzureRmStorageAccountKey -ResourceGroupName $destinationResourceGroupName -Name $destinationStorageAccountName).Value[0]
$destinationCreds=New-Object Microsoft.WindowsAzure.Storage.Auth.StorageCredentials("$destinationStorageAccountName", $destinationKeys)
$destinationCloudStorageAccount=New-Object Microsoft.WindowsAzure.Storage.CloudStorageAccount($destinationCreds,$true)
$destinationCloudBlobClient=$destinationCloudStorageAccount.CreateCloudBlobClient()
$destinationBlobContainer=$destinationCloudBlobClient.GetContainerReference($destinationContainerName)
$destinationBlob=$destinationBlobContainer.GetBlobReference($destinationBlobName)

$sourceKeys=(Get-AzureRmStorageAccountKey -ResourceGroupName $sourceStorageAccountResourceGroup -Name $sourceStorageAccountName).Value[0]
$sourceCreds=New-Object Microsoft.WindowsAzure.Storage.Auth.StorageCredentials("$sourceStorageAccountName", $sourceKeys)
$sourceCloudStorageAccount=New-Object Microsoft.WindowsAzure.Storage.CloudStorageAccount($sourceCreds,$true)
$sourceCloudBlobClient=$sourceCloudStorageAccount.CreateCloudBlobClient()
$sourceBlobContainer=$sourceCloudBlobClient.GetContainerReference($sourceContainerName)
$sourceBlob=$sourceBlobContainer.GetBlobReference($sourceblobName)


if($targetBlob.Properties.LeaseStatus -eq 'locked'){
  "There is a lease on the destination blob, breaking..."
  try{
    $targetBlob.BreakLease($(New-TimeSpan), $null,$null,$null)
  Start-Sleep 20

  }
  catch {
  Write-Output "There is a problem with the breaking lease "
  }
}
if($sourceBlob.Properties.LeaseStatus -eq 'locked'){
    "There is a lease on the destination blob, breaking..."
    try{
      $sourceBlob.BreakLease($(New-TimeSpan), $null,$null,$null)
      Start-Sleep 20
    }
  catch {
    Write-Output "There is a problem with  breaking the lease "
  }
}

try{
  $result= Start-CopyAzureStorageBlob -SrcBlob $sourceblobName -Context $sourceStorageContext -SrcContainer $sourceContainerName -DestContainer $destinationContainerName -DestBlob $destinationblob -DestContext $destinationStorageContext -Verbose -Force
  if(-not ($null -eq $result)){
    Write-Output "Transfer Succesfully completed"
  }
}
catch {
  Write-Error "There was an error!"
}  
