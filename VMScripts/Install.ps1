#========================================================================
param(
    $rdp,
    $Parsec,
    $ParsecVDD,
    $secondCall,
    $team_id,
    $key
) 
$psscriptIni = 
@"
[Logon]
0CmdLine=Install.ps1
0Parameters=$rdp $Parsec $ParsecVDD $true $Team_ID $Key
"@
#========================================================================

#========================================================================
function Remove-File {
    param([Parameter(Mandatory = $true)][string]$Path)
    if (Test-Path $Path) { Remove-Item $Path -Force }
}
#========================================================================

#========================================================================
Remove-File "C:\unattend.xml"
if ($SecondCall -eq $true) {
    Remove-File "C:\Windows\system32\GroupPolicy\User\Scripts\psscripts.ini"
    Remove-File "C:\Windows\system32\GroupPolicy\User\Scripts\Logon\nstall.ps1"
    Exit
}
#========================================================================

#========================================================================
function Allow-InBoundConnections {
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
        Get-PnpDevice | Where-Object {$_.friendlyname -like "Microsoft Hyper-V Video" -and $_.status -eq "OK"} | Disable-PnpDevice -confirm:$false
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
    Allow-InBoundConnections
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

Set-Content -path C:\Windows\system32\GroupPolicy\User\Scripts\psscripts.ini -value $psscriptIni
#========================================================================