Import-Module Azure
Login-AzureRmAccount
Set-AzureRmContext -SubscriptionId 21bbfb75-e419-4a5f-b2ce-103c5b2a73a2
$resourceGroup = "CHAP1"
$vmName = "SRV1"
$storageName = "sandboxkc"
Publish-AzureRmVMDscConfiguration -ConfigurationPath 'C:\Users\kapil.chadha\OneDrive - Avanade\3. Training\1. Azure\70-532\Book\Ch1\DSC\iisInstallandEnsureWebPage.ps1' `
    -ResourceGroupName $resourceGroup -StorageAccountName $storageName -Force
Set-AzureRmVmDscExtension -Version 2.21 `
    -ResourceGroupName $resourceGroup `
    -VMName $vmName `
    -ArchiveStorageAccountName $storageName `
    -ArchiveBlobName iisInstallandEnsureWebPage.ps1.zip `
    -AutoUpdate:$true `
    -ConfigurationName DeployWebPage
