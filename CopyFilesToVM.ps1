$VMname = "VM Name HERE"
$hostname = $ENV:COMPUTERNAME
$DriveLetter = "X:"


$path = (Get-VM -VMName $VMname | Select-Object -Property VMId | Get-VHD).path
$Unique = (Mount-VHD -Path $path -PassThru | Get-Disk | Get-Partition | Get-Volume | Where-Object size -GT 10GB)
Get-Volume -UniqueId $unique.UniqueId | Get-Partition | Add-PartitionAccessPath -AccessPath $DriveLetter

# Get Third Party drivers used, that are not provided by Microsoft and presumably included in the OS
$drivers = Get-WmiObject Win32_PNPSignedDriver | where {$_.DriverProviderName -eq "NVIDIA"}

New-Item -ItemType Directory -Path "$DriveLetter\windows\system32\HostDriverStore" -Force | Out-Null

# Initialize the list of detected driver packages as an array
$DriverFolders = @()
foreach ($d in $drivers) {
    # We initialize the list of driver files for each driver
    $DriverFiles = @()
    # For each driver instance from WMI class Win32_PNPSignedDriver, we compose the related WMI object name from the other WMI driver class, Win32_PNPSignedDriverCIMDataFile
    $ModifiedDeviceID = $d.DeviceID -replace "\\", "\\"
    $Antecedent = "\\" + $hostname + "\ROOT\cimv2:Win32_PNPSignedDriver.DeviceID=""$ModifiedDeviceID"""
    # Get all related driver files for each driver listed in WMI class Win32_PNPSignedDriver
    $DriverFiles += Get-WmiObject Win32_PNPSignedDriverCIMDataFile | where {$_.Antecedent -eq $Antecedent}
    $DriverName = $d.DeviceName
    $DriverID = $d.DeviceID
    Write-Host "####Driver files for driver with name: $DriverName" -ForegroundColor Green
    Write-Host "and with DriverID: $DriverID" -ForegroundColor Green
    if ($DriverName -like "NVIDIA*") {New-Item -ItemType Directory -Path "$driveletter\Windows\System32\drivers\Nvidia Corporation\" -Force | Out-Null}
    foreach ($i in $DriverFiles) {
            # We elliminate double backslashes from the file paths
            $path = $i.Dependent.Split("=")[1] -replace '\\\\', '\'
            $path2 = $path.Substring(1,$path.Length-2)
            $InfItem = Get-Item -Path $path2
            $Version = $InfItem.VersionInfo.FileVersion
            If ($path2 -like "c:\windows\system32\driverstore\*") {
            $ParseDestination = $path2.Replace("c:","$driveletter").Replace("driverstore","HostDriverStore")
            $Destination = $ParseDestination.SubString(0, $ParseDestination.LastIndexOf('\'))
            New-Item -ItemType Directory -Path "$Destination" -Force | Out-Null
            Copy-Item $path2 -Destination $Destination -Force 
            Write-Host "Copied $path2 to $Destination" -ForegroundColor Green
            }
            Else {
            $ParseDestination = $path2.Replace("c:", "$driveletter")
            $Destination = $ParseDestination.Substring(0, $ParseDestination.LastIndexOf('\'))
            if (!$(Get-Item -Path $Destination -ErrorAction SilentlyContinue).Exists ) {
                New-Item -ItemType Directory -Path $Destination -Force | Out-Null
                }
            Copy-Item $path2 -Destination $Destination -Force
            Write-Host "Copied $path2 to $Destination" -ForegroundColor Green
            }

    }
    }
Get-Volume -UniqueId $unique.UniqueId | Get-Partition | Remove-PartitionAccessPath -AccessPath $driveLetter
Dismount-vhd -Path $path
