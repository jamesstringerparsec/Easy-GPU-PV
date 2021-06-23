Function New-GPUEnabledVM {
param(
[int64]$HDDSize = 40GB,
[string]$VMName = "GPU-P",
[int64]$MemoryAmount = 8GB,
[int]$CPUCores = 4,
[Parameter(Mandatory=$true)][string]$WindowsISOPath = ""
)
    New-vhd -SizeBytes $HDDSize -Path "C:\Users\Public\Documents\Hyper-V\Virtual hard disks\$VMName.vhdx" -Dynamic
    New-VM -Name $VMName -MemoryStartupBytes $MemoryAmount -VHDPath "C:\Users\Public\Documents\Hyper-V\Virtual hard disks\$VMName.vhdx" -Generation 2 -SwitchName "Default Switch"
    Set-VM -Name $VMName -ProcessorCount $CPUCore -CheckpointType Disabled -LowMemoryMappedIoSpace 3GB -HighMemoryMappedIoSpace 32GB
    Set-VMMemory -VMName $VMName -DynamicMemoryEnabled $false
    Add-VMDvdDrive -VMName $VMName -Path $ISOPath
}

Function Get-VMGpuPartitionAdapterFriendlyName {
    $Devices = (Get-VMHostPartitionableGpu).Name
    Foreach ($GPU in $Devices) {
        $GPUParse = $GPU.Split('#')[1]
        Get-WmiObject Win32_PNPSignedDriver | where {($_.HardwareID -eq "PCI\$GPUParse")} | select DeviceName -ExpandProperty DeviceName
        }
}

Get-VMGpuPartitionAdapterFriendlyName


function Assign-VMGPUPartitionAdapter {
param(
[string]$VMName,
[string]$GPUName
)
    $DeviceID = ((Get-WmiObject Win32_PNPSignedDriver | where {($_.Devicename -eq "$GPUNAME")}).hardwareid).split('\')[1]
    $DevicePathName = (Get-VMHostPartitionableGpu | Where-Object name -like "*$deviceid*").Name
    Add-VMGpuPartitionAdapter -VMName $VMName -InstancePath $DevicePathName
}

Assign-VMGPUPartitionAdapter -GPUName "NVIDIA GeForce RTX 2060 SUPER" -VMName "GPU-P"






