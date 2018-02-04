#Login-AzureRmAccount

#$mySubscriptionId = (Get-AzureRmSubscription).SubscriptionId
#$mySubscriptionId = "<SUB-ID>"
$myResourceGroup = "ScaleSetUsingPortal"
$myScaleSet = "ssPortal"
$myLocation = "Uk South"

$myRuleScaleOut = New-AzureRmAutoscaleRule `
  -MetricName "Percentage CPU" `
  -MetricResourceId /subscriptions/$mySubscriptionId/resourceGroups/$myResourceGroup/providers/Microsoft.Compute/virtualMachineScaleSets/$myScaleSet `
  -TimeGrain 00:01:00 `
  -MetricStatistic Average `
  -TimeWindow 00:10:00 `
  -Operator GreaterThan `
  -Threshold 70 `
  -ScaleActionDirection Increase `
  –ScaleActionScaleType PercentChangeCount `
  -ScaleActionValue 20 `
  -ScaleActionCooldown 00:05:00

$myRuleScaleIn = New-AzureRmAutoscaleRule `
  -MetricName "Percentage CPU" `
  -MetricResourceId /subscriptions/$mySubscriptionId/resourceGroups/$myResourceGroup/providers/Microsoft.Compute/virtualMachineScaleSets/$myScaleSet `
  -Operator LessThan `
  -MetricStatistic Average `
  -Threshold 30 `
  -TimeGrain 00:01:00 `
  -TimeWindow 00:10:00 `
  -ScaleActionCooldown 00:05:00 `
  -ScaleActionDirection Decrease `
  –ScaleActionScaleType PercentChangeCount `
  -ScaleActionValue 20


$myScaleProfile = New-AzureRmAutoscaleProfile `
  -DefaultCapacity 2  `
  -MaximumCapacity 10 `
  -MinimumCapacity 2 `
  -Rules $myRuleScaleOut,$myRuleScaleIn `
  -Name "autoprofile"

Add-AzureRmAutoscaleSetting `
  -Location $myLocation `
  -Name "autosetting" `
  -ResourceGroup $myResourceGroup `
  -TargetResourceId /subscriptions/$mySubscriptionId/resourceGroups/$myResourceGroup/providers/Microsoft.Compute/virtualMachineScaleSets/$myScaleSet `
  -AutoscaleProfiles $myScaleProfile

#Get-AzureRmVmssVM -ResourceGroupName "ScaleSetUsingPortal" -VMScaleSetName "ssPortal"




