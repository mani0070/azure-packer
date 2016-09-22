Write-Host "Starting file script..." 

Write-Host 'Executing [DateTime]::Now...' 
[DateTime]::Now

if(test-path ("c:\temp"))
{ new-item -ItemType file -Name "Hello.txt"}
else
{new-item  -ItemType Directory  -Name "Temp"}


$Parameters = @{
        "FeatureName" = "Web-Server"
        "IsPresent" = $False
}


Start-AzureRmAutomationDscCompilationJob -ResourceGroupName "MyResourceGroup" -AutomationAccountName "MyAutomationAccount" -ConfigurationName "ParametersExample" -Parameters $Parameters
