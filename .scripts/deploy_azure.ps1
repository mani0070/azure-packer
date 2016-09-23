
#parameters:
    [string] $ResourceGroupLocation="westeurope"
    [string] $ResourceGroupName = 'demo'
    [string] $TemplateFile = '..\Templates\basic.json'
    [string] $TemplateParametersFile = '..\Templates\basic.parameters.json'
 
 # Create or update the resource group using the specified template file and template parameters file
New-AzureRmResourceGroup -Name $ResourceGroupName -Location $ResourceGroupLocation -Verbose -Force -ErrorAction Stop 

Set-location $PSScriptRoot
New-AzureRmResourceGroupDeployment -Name ((Get-ChildItem $TemplateFile).BaseName + '-' + ((Get-Date).ToUniversalTime()).ToString('MMdd-HHmm')) `
                                   -ResourceGroupName $ResourceGroupName `
                                   -TemplateFile $TemplateFile `
                                   -TemplateParameterFile $TemplateParametersFile `
                                   -Force -Verbose
