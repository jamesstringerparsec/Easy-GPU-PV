Param (
[string]$VMName,
[string]$GPUName,
[string]$Hostname = $ENV:Computername
)

Function Add-VMGpuPartitionAdapterFiles {
param(
[string]$hostname = $ENV:COMPUTERNAME,
[string]$DriveLetter,
[string]$GPUName
)

# Get Third Party drivers used, that are not provided by Microsoft and presumably included in the OS
$drivers = Get-WmiObject Win32_PNPSignedDriver | where {$_.DeviceName -eq "$GPUName"}

New-Item -ItemType Directory -Path "$DriveLetter\windows\system32\HostDriverStore" -Force | Out-Null

#copy directory associated with sys file 
$service = Get-PnpDevice | Where-Object {$_.Name -eq "$GPUName"} | Select-Object Service -ExpandProperty Service
$servicePath = (Get-WmiObject Win32_SystemDriver | Where-Object {$_.Name -eq "$service"}).Pathname
                $ServiceDriverDir = $servicepath.split('\')[0..5] -join('\')
                $ServicedriverDest = ("$driveletter" + "\" + $($servicepath.split('\')[1..5] -join('\'))).Replace("DriverStore","HostDriverStore")
                if (!(Test-Path $ServicedriverDest)) {
                Copy-item -path "$ServiceDriverDir" -Destination "$ServicedriverDest" -Recurse
                }

# Initialize the list of detected driver packages as an array
$DriverFolders = @()
foreach ($d in $drivers) {

    $DriverFiles = @()
    $ModifiedDeviceID = $d.DeviceID -replace "\\", "\\"
    $Antecedent = "\\" + $hostname + "\ROOT\cimv2:Win32_PNPSignedDriver.DeviceID=""$ModifiedDeviceID"""
    $DriverFiles += Get-WmiObject Win32_PNPSignedDriverCIMDataFile | where {$_.Antecedent -eq $Antecedent}
    $DriverName = $d.DeviceName
    $DriverID = $d.DeviceID
    if ($DriverName -like "NVIDIA*") {
        New-Item -ItemType Directory -Path "$driveletter\Windows\System32\drivers\Nvidia Corporation\" -Force | Out-Null
        }
    foreach ($i in $DriverFiles) {
            $path = $i.Dependent.Split("=")[1] -replace '\\\\', '\'
            $path2 = $path.Substring(1,$path.Length-2)
            $InfItem = Get-Item -Path $path2
            $Version = $InfItem.VersionInfo.FileVersion
            If ($path2 -like "c:\windows\system32\driverstore\*") {
                $DriverDir = $path2.split('\')[0..5] -join('\')
                $driverDest = ("$driveletter" + "\" + $($path2.split('\')[1..5] -join('\'))).Replace("driverstore","HostDriverStore")
                if (!(Test-Path $driverDest)) {
                Copy-item -path "$DriverDir" -Destination "$driverDest" -Recurse
                }
            }
            Else {
                $ParseDestination = $path2.Replace("c:", "$driveletter")
                $Destination = $ParseDestination.Substring(0, $ParseDestination.LastIndexOf('\'))
                if (!$(Test-Path -Path $Destination)) {
                    New-Item -ItemType Directory -Path $Destination -Force | Out-Null
                    "New Item $Destination"
                    }
                Copy-Item $path2 -Destination $Destination -Force
                "Copy Item $Path2 to $Destination"
                
            }

    }
    }

}

$VM = Get-VM -VMName $VMName
$VHD = Get-VHD -VMId $VM.VMId

If ($VM.state -eq "Running") {
    [bool]$state_was_running = $true
    }

if ($VM.state -ne "Off"){
    "Attemping to shutdown VM..."
    Stop-VM -Name $VMName -Force
    } 

While ($VM.State -ne "Off") {
    Start-Sleep -s 3
    "Waiting for VM to shutdown - make sure there are no unsaved documents..."
    }

"Mounting Drive..."
$DriveLetter = (Mount-VHD -Path $VHD.Path -PassThru | Get-Disk | Get-Partition | Get-Volume | Where-Object {$_.DriveLetter} | ForEach-Object DriveLetter) + ":"

"Copying GPU Files - this could take a while..."
Add-VMGPUPartitionAdapterFiles -hostname $Hostname -DriveLetter $DriveLetter -GPUName $GPUName

"Dismounting Drive..."
Dismount-VHD -Path $VHD.Path

If ($state_was_running){
    "Previous State was running so starting VM..."
    Start-VM $VMName
    }

"Done..."