Function Add-VMGpuPartitionAdapterFiles {
param(
[string]$hostname = $ENV:COMPUTERNAME,
[string]$DriveLetter,
[string]$GPUName
)

# Get Third Party drivers used, that are not provided by Microsoft and presumably included in the OS
$drivers = Get-WmiObject Win32_PNPSignedDriver | where {$_.DeviceName -eq "$GPUName"}

#New-Item -ItemType Directory -Path "$DriveLetter\windows\system32\HostDriverStore" -Force | Out-Null

# Initialize the list of detected driver packages as an array
$DriverFolders = @()
foreach ($d in $drivers) {

    $DriverFiles = @()
    $ModifiedDeviceID = $d.DeviceID -replace "\\", "\\"
    $Antecedent = "\\" + $hostname + "\ROOT\cimv2:Win32_PNPSignedDriver.DeviceID=""$ModifiedDeviceID"""
    $DriverFiles += Get-WmiObject Win32_PNPSignedDriverCIMDataFile | where {$_.Antecedent -eq $Antecedent}
    $DriverName = $d.DeviceName
    $DriverID = $d.DeviceID
    $driverID 
    $drivername
    if ($DriverName -like "NVIDIA*") {
        #New-Item -ItemType Directory -Path "$driveletter\Windows\System32\drivers\Nvidia Corporation\" -Force | Out-Null
        }
    foreach ($i in $DriverFiles) {
            $i.dependent
            $path = $i.Dependent.Split("=")[1] -replace '\\\\', '\'
            $path2 = $path.Substring(1,$path.Length-2)
            $InfItem = Get-Item -Path $path2
            $Version = $InfItem.VersionInfo.FileVersion
            If ($path2 -like "c:\windows\system32\driverstore\*") {
                #$path2.IndexOf('\')
            }
            Else {
                $ParseDestination = $path2.Replace("c:", "$driveletter")
                $Destination = $ParseDestination.Substring(0, $ParseDestination.LastIndexOf('\'))
                if (!$(Test-Path -Path $Destination)) {
                    #New-Item -ItemType Directory -Path $Destination -Force | Out-Null
                    "New Item $Destination"
                    }
                #Copy-Item $path2 -Destination $Destination -Force
                "Copy Item $Path2 to $Destination"
                
            }

    }
    }

}

Add-VMGpuPartitionAdapterFiles -Driveletter "Z:" -GPUName "AMD Radeon RX 5700 XT"

<#
driveletter = "Z:"

$path = "c:\windows\system32\driverstore\FileRepository\ABD\12345"

$DriverDir = $path2.split('\')[0..5] -join('\')

$driverDest = ("$driveletter" + "\" + $($path2.split('\')[1..5] -join('\'))).Replace("driverstore","HostDriverStore")

if (!(Test-Path $driverDest)) {
Copy-item $DriverDir -Destination $driverDest -Recurse
}


#>



#$Device = Get-WmiObject Win32_PNPSignedDriver | where {$_.DeviceName -eq "AMD Radeon RX 5700 XT"}
$device = Get-PnpDevice -FriendlyName "AMD Radeon RX 5700 XT"
$ModifiedDeviceID = $Device.DeviceID -replace "\\", "\\"
$Antecedent = "\\" + $ENV:Computername + "\ROOT\cimv2:Win32_PNPEntity.DeviceID=""$ModifiedDeviceID"""
$antecedent
$SystemDriverPNPEntry = Get-WmiObject Win32_PNPSignedDriverCIMDataFile | where {$_.Antecedent -eq $Antecedent} | Select-Object -First 1
$SystemDriverFileObject = Get-WmiObject Win32_SystemDriver | Where-Object {$_.Name -eq "$(Get-PnpDevice | Where-Object {$_.Name -eq "AMD Radeon RX 5700 XT"} | Select-Object Service -ExpandProperty Service)"}
$SystemDriverFileObject
$deviceid = (Get-PnpDevice | Where-Object {$_.Name -eq "AMD Radeon RX 5700 XT"}).DeviceID
Get-WindowsDriver -Online | Where-Object {$_.DeviceID -eq $deviceid}



$service = Get-PnpDevice | Where-Object {$_.Name -eq $gpuname} | Select-Object Service -ExpandProperty Service
$servicePath = (Get-WmiObject Win32_SystemDriver | Where-Object {$_.Name -eq "$service"}).Pathname
$servicepath


Get-WmiObject Win32_PNPSignedDriver | where {$_.DeviceName -eq "AMD Radeon RX 5700 XT"}
$Antecedent = "\\" + $ENV:Computername + "\ROOT\cimv2:Win32_PNPEntity.DeviceID=""PCI\\VEN_1002&DEV_731F&SUBSYS_04E21043&REV_C1\\A&112FA587&0&00000008000800D8D"""


Get-WmiObject Win32_PNPSignedDriverCIMDataFile | where {$_.Antecedent -eq $Antecedent}

$drivers = Get-WmiObject Win32_PNPSignedDriver | where {$_.DeviceName -eq "AMD Radeon RX 5700 XT"}
$ModifiedDeviceID = $Device.DeviceID -replace "\\", "\\"
$Antecedent = "\\" + $ENV:Computername + "\ROOT\cimv2:Win32_PNPEntity.DeviceID=""$ModifiedDeviceID"""
-WmiObject Win32_PNPSignedDriverCIMDataFile | where {$_.Antecedent -eq $Antecedent}