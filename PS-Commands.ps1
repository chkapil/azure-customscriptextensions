<#
List VMAccessAgent
#>
Get-AzureRmVMExtensionImage -PublisherName "Microsoft.Compute" -Type "VMAccessAgent"

<#
Add Custom Script Extension using PowerShell
#>
Set-AzureRmVMCustomScriptExtension -ResourceGroupName "Chap1" -Location "UK South" -VMName "SRV1" -Name "TestCSExtPS" -StorageAccountName "sandboxkc" -FileName "CS-Ext-PS.ps1" -ContainerName "scripts"

