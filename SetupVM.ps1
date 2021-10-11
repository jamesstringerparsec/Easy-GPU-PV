Function New-GPUEnabledVM {
param(
[int64]$HDDSize = 40GB,
[string]$VMName = "GPU-P",
[int64]$MemoryAmount = 8GB,
[int]$CPUCores = 4,
[string]$WindowsISOPath = "C:\Users\james\Downloads\Windows11_InsiderPreview_Client_x64_en-us__22000.iso"
)
    New-vhd -SizeBytes $HDDSize -Path "C:\Users\Public\Documents\Hyper-V\Virtual hard disks\$VMName.vhdx" -Dynamic
    New-VM -Name $VMName -MemoryStartupBytes $MemoryAmount -VHDPath "C:\Users\Public\Documents\Hyper-V\Virtual hard disks\$VMName.vhdx" -Generation 2 -SwitchName "Default Switch"
    Set-VM -Name $VMName -ProcessorCount $CPUCores -CheckpointType Disabled -LowMemoryMappedIoSpace 3GB -HighMemoryMappedIoSpace 32GB -GuestControlledCacheTypes $true -AutomaticStopAction ShutDown
    Set-VMMemory -VMName $VMName -DynamicMemoryEnabled $false
    Add-VMDvdDrive -VMName $VMName -Path $WindowsISOPath
    Set-VMFirmware -VMName $VMName -BootOrder $((Get-VMFirmware -VMName "GPU-P").BootOrder.Device | Where-Object name -like "DVD*"), $((Get-VMFirmware -VMName "GPU-P").BootOrder.Device | Where-Object name -like "Hard Drive*"), $((Get-VMFirmware -VMName "GPU-P").BootOrder.Device | Where-Object name -like "Network Adapter*")
}

Function Get-VMGpuPartitionAdapterFriendlyName {
    $Devices = (Get-VMHostPartitionableGpu).Name
    Foreach ($GPU in $Devices) {
        $GPUParse = $GPU.Split('#')[1]
        Get-WmiObject Win32_PNPSignedDriver | where {($_.HardwareID -eq "PCI\$GPUParse")} | select DeviceName -ExpandProperty DeviceName
        }
}


function Assign-VMGPUPartitionAdapter {
param(
[string]$VMName,
[string]$GPUName
)
    $DeviceID = ((Get-WmiObject Win32_PNPSignedDriver | where {($_.Devicename -eq "$GPUNAME")}).hardwareid).split('\')[1]
    $DevicePathName = (Get-VMHostPartitionableGpu | Where-Object name -like "*$deviceid*").Name
    Add-VMGpuPartitionAdapter -VMName $VMName -InstancePath $DevicePathName
    Set-VMGpuPartitionAdapter -VMName $VMName -MinPartitionVRAM 0 -MaxPartitionVRAM 1000000000 -OptimalPartitionVRAM 1000000000 
    Set-VMGPUPartitionAdapter -VMName $VMName -MinPartitionEncode 0 -MaxPartitionEncode 18446744073709551615 -OptimalPartitionEncode 18446744073709551615
    Set-VMGpuPartitionAdapter -VMName $VMName -MinPartitionDecode 0 -MaxPartitionDecode 1000000000 -OptimalPartitionDecode 1000000000
    Set-VMGpuPartitionAdapter -VMName $VMName -MinPartitionCompute 0 -MaxPartitionCompute 1000000000 -OptimalPartitionCompute 1000000000
}

Assign-VMGPUPartitionAdapter -GPUName "NVIDIA GeForce RTX 2060 SUPER" -VMName "GPU-P"

