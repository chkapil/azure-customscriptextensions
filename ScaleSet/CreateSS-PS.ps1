#Login-AzureRmAccount

$resourceGroup = "ScaleSetFromPS"

New-AzureRmResourceGroup -ResourceGroupName $resourceGroup -Location "UK South"

$subnet = New-AzureRmVirtualNetworkSubnetConfig `
    -Name "ssSubnet" `
    -AddressPrefix 10.0.0.0/24

$vnet = New-AzureRmVirtualNetwork `
    -ResourceGroupName $resourceGroup `
    -Name "ssVNet" `
    -Location "UK South" `
    -AddressPrefix 10.0.0.0/16 `
    -Subnet $subnet

$publicIP = New-AzureRmPublicIpAddress `
    -ResourceGroupName $resourceGroup `
    -Location "UK South" `
    -AllocationMethod Static `
    -Name "ssPublicIP"

$frontendIP = New-AzureRmLoadBalancerFrontendIpConfig `
    -Name "ssFrontendPool" `
    -PublicIpAddress $publicIP

$backendPool = New-AzureRmLoadBalancerBackendAddressPoolConfig -Name "ssBackEndPool"

$inboundNATPool = New-AzureRmLoadBalancerInboundNatPoolConfig `
    -Name "ssRDPRule" `
    -FrontendIpConfigurationId $frontendIP.Id `
    -Protocol TCP `
    -FrontendPortRangeStart 50001 `
    -FrontendPortRangeEnd 50010 `
    -BackendPool 3389

$lb = New-AzureRmLoadBalancer `
    -ResourceGroupName $resourceGroup `
    -Name "ssLoadBalancer" `
    -Location "Uk South" `
    -FrontendIPConfiguration $frontendIP `
    -BackendAddressPool $backendPool `
    -InboundNatPool $inboundNATPool

Add-AzureRmLoadBalancerProbeConfig -Name "ssHealthProbe" `
    -LoadBalancer $lb `
    -Protocol Tcp `
    -Port 80 `
    -IntervalInSeconds 15 `
    -ProbeCount 2

Add-AzureRmLoadBalancerRuleConfig `
    -Name "ssLoadBalancerRule" `
    -LoadBalancer $lb `
    -FrontendIpConfiguration $lb.FrontendIpConfigurations[0] `
    -BackendAddressPool $lb.BackendAddressPools[0] `
    -Protocol Tcp `
    -FrontendPort 80 `
    -BackendPort 80
<#

Add-AzureRmLoadBalancerInboundNatPoolConfig `
    -Name "ssNatPoolConfig" `
    -LoadBalancer $lb `
    -FrontendIpConfiguration $lb.FrontendIpConfigurations[0] `
    -Protocol Tcp `
    -FrontendPortRangeStart 50001 `
    -FrontendPortRangeEnd 50010 `
    -BackendPort 3389

Add-AzureRmLoadBalancerInboundNatRuleConfig `
    -Name "ssNatRuleConfig" `
    -LoadBalancer $lb `
    -FrontendIpConfiguration $lb.FrontendIpConfigurations[0] `
    -Protocol Tcp `
    -FrontendPort 50001 `
    -BackendPort 3389

Add-AzureRmLoadBalancerInboundNatRuleConfig `
    -Name "ssNatRuleConfig" `
    -LoadBalancer $lb `
    -FrontendIpConfiguration $lb.FrontendIpConfigurations[0] `
    -Protocol Tcp `
    -FrontendPort 50002 `
    -BackendPort 3389
    
  #>

Set-AzureRmLoadBalancer -LoadBalancer $lb

$ipConfig = New-AzureRmVmssIpConfig `
    -Name "ssIPConfig" `
    -LoadBalancerBackendAddressPoolsId $lb.BackendAddressPools[0].Id `
    -LoadBalancerInboundNatPoolsId $inboundNATPool.Id `
    -SubnetId $vnet.Subnets[0].Id

#Create ScaleSet

$securePassword = "P@ssword!"
$adminUsername = "sysadmin"

$vmssConfig = New-AzureRmVmssConfig `
    -Location "Uk South" `
    -SkuCapacity 2 `
    -SkuName "Standard_DS1_v2" `
    -UpgradePolicyMode Automatic

Set-AzureRmVmssStorageProfile $vmssConfig `
  -ImageReferencePublisher "MicrosoftWindowsServer" `
  -ImageReferenceOffer "WindowsServer" `
  -ImageReferenceSku "2016-Datacenter" `
  -ImageReferenceVersion "latest"

Set-AzureRmVmssOsProfile $vmssConfig `
  -AdminUsername $adminUsername `
  -AdminPassword $securePassword `
  -ComputerNamePrefix "ssVM"

Add-AzureRmVmssNetworkInterfaceConfiguration `
  -VirtualMachineScaleSet $vmssConfig `
  -Name "network-config" `
  -Primary $true `
  -IPConfiguration $ipConfig

New-AzureRmVmss `
  -ResourceGroupName $resourceGroup `
  -Name "ssScaleSet" `
  -VirtualMachineScaleSet $vmssConfig
  

  ##########################


  # Define the script for your Custom Script Extension to run
$publicSettings = @{
    "fileUris" = (,"https://raw.githubusercontent.com/Azure-Samples/compute-automation-configurations/master/automate-iis.ps1");
    "commandToExecute" = "powershell -ExecutionPolicy Unrestricted -File automate-iis.ps1"
}

# Get information about the scale set
$vmss = Get-AzureRmVmss `
            -ResourceGroupName "ScaleSetFromPS" `
            -VMScaleSetName "ssScaleSet"

# Use Custom Script Extension to install IIS and configure basic website
Add-AzureRmVmssExtension -VirtualMachineScaleSet $vmss `
    -Name "customScript" `
    -Publisher "Microsoft.Compute" `
    -Type "CustomScriptExtension" `
    -TypeHandlerVersion 1.8 `
    -Setting $publicSettings

# Update the scale set and apply the Custom Script Extension to the VM instances
Update-AzureRmVmss `
    -ResourceGroupName "ScaleSetFromPS" `
    -Name "ssScaleSet" `
    -VirtualMachineScaleSet $vmss
    


  ###############################



  $lb1= Get-AzureRmLoadBalancer -Name "ssLoadBalancer" -ResourceGroupName "ScaleSetFromPS"
  
  <#
Add-AzureRmLoadBalancerInboundNatPoolConfig `
    -Name "ssNatPoolConfig1" `
    -LoadBalancer $lb1 `
    -FrontendIpConfiguration $lb1.FrontendIpConfigurations[0] `
    -Protocol Tcp `
    -FrontendPortRangeStart 60001 `
    -FrontendPortRangeEnd 60010 `
    -BackendPort 3389  
    #>
    
    Add-AzureRmLoadBalancerInboundNatRuleConfig `
    -Name "ssNatRuleConfig1" `
    -LoadBalancer $lb1 `
    -FrontendIpConfiguration $lb1.FrontendIpConfigurations[0] `
    -Protocol Tcp `
    -FrontendPort 70001 `
    -BackendPort 3389

Add-AzureRmLoadBalancerInboundNatRuleConfig `
    -Name "ssNatRuleConfig2" `
    -LoadBalancer $lb1 `
    -FrontendIpConfiguration $lb1.FrontendIpConfigurations[0] `
    -Protocol Tcp `
    -FrontendPort 70002 `
    -BackendPort 3389  
 
 
Set-AzureRmLoadBalancer -LoadBalancer $lb1





































