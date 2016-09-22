# Mandatory : update the username and the subscription id .
# optional : change the password

$username = 'username@directoryname.onmicrosoft.com'
$subscriptionid = 'xxxxxxx-xxxxx-xxxx-xxxx-xxxxxx'
$password =  'Ihatey0u!' | ConvertTo-SecureString -AsPlainText -Force
$cred = new-object -typename System.Management.Automation.PSCredential `
         -argumentlist $username, $password

Add-AzureRmAccount -Credential $cred -SubscriptionId $subscriptionid

