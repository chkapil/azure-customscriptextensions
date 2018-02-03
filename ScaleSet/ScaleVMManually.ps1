Login-AzureRmAccount

$ResourceGroupName = "CHAP1"
$VMName = "SRV1"
<#$NEWVMSize = "Standard_DS11_v2"#>
$NEWVMSize = "Standard_DS1_v2"
$vm = Get-AzureRmVM -ResourceGroupName $ResourceGroupName -Name $VMName
$vm.HardwareProfile.VmSize = $NEWVMSize
Update-AzureRmVM -ResourceGroupName $ResourceGroupName -VM $vm