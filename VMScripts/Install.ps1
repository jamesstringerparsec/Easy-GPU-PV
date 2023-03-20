#========================================================================
param(
    $rdp,
    $Parsec,
    $ParsecVDD,
    $DisableHVDD,
    $NumLock,
    $team_id,
    $key
) 
#========================================================================

#========================================================================
if ($NumLock -eq $true) {
    $WshShell = New-Object -ComObject WScript.Shell
    if ([console]::NumberLock -eq $false) {
        $WshShell.SendKeys("{NUMLOCK}")
    }
}
#========================================================================

#========================================================================
function Set-RegistryPolicyItem {
    param(
        [Parameter(Mandatory = $true)]
        [string]
        [ValidateNotNullOrEmpty()]$path,
        [Parameter(Mandatory = $true)]
        [string]
        [ValidateNotNullOrEmpty()]$name,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]$value,
        [int]$type,
        [switch]$Force
    )

    $RegPolPath = "$env:SystemRoot\System32\GroupPolicy\Machine\Registry.pol"
    
    if ($type -eq 0) {
        $type = switch ($value.GetType().Fullname) {
            'System.String' { 1  }
            'System.Int32'  { 4  }
            'System.Int64'  { 11 }
            default { return }
        }
    }
    
    function PolToUpperCase {
        param(
            [int[]]$data
        ) 
        return $data | % -begin {$nameSection=$false} -process {
            if ($_ -eq 91)    { $nameSection = $true } 
            elseif($_ -eq 65) { $nameSection = $false }
            elseif($_ -ge 97 -and $_ -le 122 -and  $nameSection) { $_ -= 32 }
            $_
        }
    }
    
    function LastIndexOfBytesPattern {
        param (
            [int[]]$data,
            [int[]]$pattern
        )
        $i, $j = 0, 0
        ForEach ($byte in $data) {
            if($byte -eq $pattern[$j++]) { 
                if($j -eq $pattern.Count) { return $i } 
            } else {
                $j = 0
            } 
            $i++
        } 
        return -1
    }
    
    if (Test-path -path $RegPolPath) {
        $rawData = [io.file]::ReadAllBytes($RegPolPath)
    } else {
        $rawData = @(80, 82, 101, 103, 1, 0, 0, 0)
    }
    
    $isUptoDate = $true
    $keyData    = [System.Text.Encoding]::Unicode.GetBytes($path)
    $NameData   = [System.Text.Encoding]::Unicode.GetBytes($name)
    
    switch ($true) {        
        ($type -eq 4 -or $type -eq 11) { $valueData  = [BitConverter]::GetBytes($value) }
        $default { $valueData  = [System.Text.Encoding]::Unicode.GetBytes($value) }
    }
    
    $pattern    = @(91, 0) + $keyData +  @(0, 0, 59, 0) + $NameData + @(0, 0, 59, 0)
    $PolicyTypeOffset = (LastIndexOfBytesPattern (PolToUpperCase $rawData) (PolToUpperCase $pattern)) + 1
    
    if ($PolicyTypeOffset -gt 0) {
        $ValueOffset = 12 + $PolicyTypeOffset
        if ($rawData[$PolicyTypeOffset] -ne $type) {
            return
        }
        for ($i = 0; $i -lt $valueData.Count; $i++) {
            if ($rawData[$i + $ValueOffset] -ne $valueData[$i]) { 
                $isUptoDate = $false 
            }
            $rawData[$i + $ValueOffset] = $valueData[$i]
        }
    } else {
        $isUptoDate = $false
        $rawData += $pattern + @($type, 0, 0, 0, 59, 0, $type, 0, 0, 0, 59, 0) + $valueData + @(93, 0)
    }
    
    if ($isUptoDate -eq $false) {
        [io.file]::WriteAllBytes($RegPolPath, $rawData)
        if ($Force -eq $true) { 
            Start-Process -FilePath "gpupdate" -ArgumentList "/force" -NoNewWindow -Wait 
        }
    }
}
#========================================================================

#========================================================================
function Remove-File {
    param([Parameter(Mandatory = $true)][string]$Path)
    if (Test-Path $Path) { Remove-Item $Path -Force }
}
#========================================================================

#========================================================================
function Set-AllowInBoundConnections {
    param()
    if ((Get-NetFirewallProfile -Profile Domain).DefaultInboundAction -ne 'Allow') {
        Set-NetFirewallProfile -Profile Domain -DefaultInboundAction 'Allow'
    }
    if ((Get-NetFirewallProfile -Profile Private).DefaultInboundAction -ne 'Allow') {
        Set-NetFirewallProfile -Profile Private -DefaultInboundAction 'Allow'
    }
    if ((Get-NetFirewallProfile -Profile Public).DefaultInboundAction -ne 'Allow') {
        Set-NetFirewallProfile -Profile Public -DefaultInboundAction 'Allow'
    }
    Set-RegistryPolicyItem -Path "SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Notifications" -Name "DisableNotifications" -Value 1
    Set-RegistryPolicyItem -Path "SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Notifications" -Name "DisableEnhancedNotifications" -Value 1
    Set-RegistryPolicyItem -Path "Software\Policies\Microsoft\Windows NT\Terminal Services" -Name "ColorDepth" -Value 4
    Set-RegistryPolicyItem -Path "Software\Policies\Microsoft\Windows NT\Terminal Services" -Name "bEnumerateHWBeforeSW" -Value 1
    Set-RegistryPolicyItem -Path "Software\Policies\Microsoft\Windows NT\Terminal Services" -Name "fEnableVirtualizedGraphics" -Value 1
    Set-RegistryPolicyItem -Path "Software\Policies\Microsoft\Windows NT\Terminal Services" -Name "AVC444ModePreferred" -Value 1
    Set-RegistryPolicyItem -Path "Software\Policies\Microsoft\Windows NT\Terminal Services" -Name "fEnableWddmDriver" -Value 0 -Force
}
#========================================================================

#========================================================================
function Install-VBCable {
    param()
    if (!(Get-WmiObject Win32_SoundDevice | Where-Object name -like "VB-Audio Virtual Cable")) {
        (New-Object System.Net.WebClient).DownloadFile("https://download.vb-audio.com/Download_CABLE/VBCABLE_Driver_Pack43.zip", "C:\Users\$env:USERNAME\Downloads\VBCable.zip")
        New-Item -Path "C:\Users\$env:Username\Downloads\VBCable" -ItemType Directory| Out-Null
        Expand-Archive -Path "C:\Users\$env:USERNAME\Downloads\VBCable.zip" -DestinationPath "C:\Users\$env:USERNAME\Downloads\VBCable"
        $pathToCatFile = "C:\Users\$env:USERNAME\Downloads\VBCable\vbaudio_cable64_win7.cat"
        $FullCertificateExportPath = "C:\Users\$env:USERNAME\Downloads\VBCable\VBCert.cer"
        $VB = @{}
        $VB.DriverFile = $pathToCatFile;
        $VB.CertName = $FullCertificateExportPath;
        $VB.ExportType = [System.Security.Cryptography.X509Certificates.X509ContentType]::Cert;
        $VB.Cert = (Get-AuthenticodeSignature -filepath $VB.DriverFile).SignerCertificate;
        [System.IO.File]::WriteAllBytes($VB.CertName, $VB.Cert.Export($VB.ExportType))
        while (((Get-ChildItem Cert:\LocalMachine\TrustedPublisher) | Where-Object {$_.Subject -like '*Vincent Burel*'}) -eq $NULL) {
            certutil -Enterprise -Addstore "TrustedPublisher" $VB.CertName
            Start-Sleep -s 5
        }
        Start-Process -FilePath "C:\Users\$env:Username\Downloads\VBCable\VBCABLE_Setup_x64.exe" -ArgumentList '-i','-h'
    }
}
#========================================================================

#========================================================================
function Install-ParsecVDD {
    param()
    if (!(Get-WmiObject Win32_VideoController | Where-Object name -like "Parsec Virtual Display Adapter")) {
        (New-Object System.Net.WebClient).DownloadFile("https://builds.Parsec.app/vdd/Parsec-vdd-0.41.0.0.exe", "C:\Users\$env:USERNAME\Downloads\Parsec-vdd.exe")
        while (((Get-ChildItem Cert:\LocalMachine\TrustedPublisher) | Where-Object {$_.Subject -like '*Parsec*'}) -eq $NULL) {
            certutil -Enterprise -Addstore "TrustedPublisher" C:\ProgramData\Easy-GPU-P\ParsecPublic.cer
            Start-Sleep -s 5
        }
        if ($DisableHVDD -eq $true) {
            Get-PnpDevice | Where-Object {($_.Instanceid | Select-String -Pattern "VMBUS") -and $_.Class -like "Display" -and $_.status -eq "OK"} | Disable-PnpDevice -confirm:$false
        }
        Start-Process "C:\Users\$env:USERNAME\Downloads\Parsec-vdd.exe" -ArgumentList "/s"
    } 
}
#========================================================================

#========================================================================
function Set-EasyGPUPScheduledTask {
    param (
        [switch]$RunOnce,
        [string]$TaskName,
        [string]$Path
    )
    if(!(Get-ScheduledTask | Where-Object { $_.TaskName -like "$($TaskName)" })) {
        $principal = New-ScheduledTaskPrincipal -UserID "NT AUTHORITY\SYSTEM" -LogonType ServiceAccount -RunLevel Highest
        $Action    = New-ScheduledTaskAction -Execute "C:\WINDOWS\system32\WindowsPowerShell\v1.0\powershell.exe" -Argument "-file $Path"
        $Trigger   = New-ScheduledTaskTrigger -AtStartup
        New-ScheduledTask -Action $Action -Trigger $Trigger -Principal $principal | Register-ScheduledTask -TaskName "$TaskName"
    } elseif ($RunOnce -eq $true) {
        Unregister-ScheduledTask -TaskName "$TaskName" -Confirm:$false
    }
}
#========================================================================

#========================================================================
while(!(Test-NetConnection Google.com).PingSucceeded){
    Start-Sleep -Seconds 1
}

Get-ChildItem -Path C:\ProgramData\Easy-GPU-P -Recurse | Unblock-File

if ($rdp -eq $true) {
    Set-AllowInBoundConnections
}

if ($Parsec -eq $true) {
    if ((Test-Path HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Parsec) -eq $false) {
        (New-Object System.Net.WebClient).DownloadFile("https://builds.parsecgaming.com/package/parsec-windows.exe", "C:\Users\$env:USERNAME\Downloads\Parsec-windows.exe")
        Start-Process "C:\Users\$env:USERNAME\Downloads\Parsec-windows.exe" -ArgumentList "/silent", "/shared","/team_id=$team_id","/team_computer_key=$key" -wait
        while (!(Test-Path C:\ProgramData\Parsec\config.txt)) {
            Start-Sleep -s 1
        }
        $configfile  = Get-Content C:\ProgramData\Parsec\config.txt
        $configfile += "host_virtual_monitors = 1"
        $configfile += "host_privacy_mode = 1"
        $configfile | Out-File C:\ProgramData\Parsec\config.txt -Encoding ascii
        Copy-Item -Path "C:\ProgramData\Easy-GPU-P\Parsec.lnk" -Destination "C:\Users\Public\Desktop"
        try {
            Stop-Process Parsecd -Force
        } catch {
        }
    }
    if ($ParsecVDD -eq $true) {
        Install-ParsecVDD
    }
    Install-VBCable 
    if ($ParsecVDD -eq $true) {
        Set-EasyGPUPScheduledTask -TaskName "Monitor Parsec VDD State" -Path "%programdata%\Easy-GPU-P\VDDMonitor.ps1"
    }
}

Remove-File "C:\unattend.xml"
Remove-File "C:\Windows\system32\GroupPolicy\User\Scripts\psscripts.ini"
Remove-File "C:\Windows\system32\GroupPolicy\User\Scripts\Logon\Install.ps1"
#========================================================================

#========================================================================
if ($NumLock -eq $true) {
    $path = "$DriveLetter\Windows\system32\GroupPolicy\User\Scripts\psscripts.ini"
    "[Logon]" >> $path
    "0CmdLine=NumLockEnable.ps1" >> $path
    "0Parameters=" >> $path
    
    $path = "$DriveLetter\Windows\system32\GroupPolicy\User\Scripts\Startup\NumLockEnable.ps1"
    "`$WshShell = New-Object -ComObject WScript.Shell" >> $path
    "if ([console]::NumberLock -eq `$false) {" >> $path
    "    `$WshShell.SendKeys(""{NUMLOCK}"")" >> $path
    "}" >> $path
}
#========================================================================
