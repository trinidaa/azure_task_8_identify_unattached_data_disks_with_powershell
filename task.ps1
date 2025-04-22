if (-not (Get-AzContext)) {
    Connect-AzAccount
}

$resourceGroupName = "mate-azure-task-5"
$vmName = "VM-ubuntu-task-2"
$diskName = "SSD-task-3"

$VirtualMachine = Get-AzVM -ResourceGroupName $resourceGroupName -Name $vmName
Remove-AzVMDataDisk -VM $VirtualMachine -Name $diskName
Update-AzVM -ResourceGroupName $resourceGroupName -VM $VirtualMachine

$allDisks = Get-AzDisk -ResourceGroupName $resourceGroupName
$unattachedDisks = $allDisks | Where-Object { $_.ManagedBy -eq $null }

if ($unattachedDisks) {
    Write-Host "foond unattached disks in '$resourceGroupName':" -ForegroundColor Yellow
    $unattachedDisks | Select-Object Name, DiskSizeGB, Sku, DiskState | Format-Table -AutoSize
} else {
    Write-Host "В '$resourceGroupName' has no unattached disks." -ForegroundColor Green
}

$unattachedDisks | ConvertTo-Json | Out-File -FilePath "$PWD\result.json" -Encoding utf8
