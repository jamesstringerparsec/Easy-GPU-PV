#========================================================================
param(
    $rdp,
    $parsec,
    $team_id,
    $key
)
$Global:SecondCall = $false   

   
while(!(Test-NetConnection Google.com).PingSucceeded){
    Start-Sleep -Seconds 1
}
Get-ChildItem -Path C:\ProgramData\Easy-GPU-P -Recurse | Unblock-File
if ($rdp -eq $true) {
    Set-EasyGPUPScheduledTask -TaskName "Allow InBound Connections" -Path "%programdata%\Easy-GPU-P\AllowInBoundConnections.ps1" -RunOnce
}
if ($parsec -eq $true) {
    if ((Test-Path HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Parsec) -eq $false) {
        if ($team_id -like "None") { $team_id = "" }
        if ($key     -like "None") { $key = "" }
        (New-Object System.Net.WebClient).DownloadFile("https://builds.parsecgaming.com/package/parsec-windows.exe", "C:\Users\$env:USERNAME\Downloads\parsec-windows.exe")
        Start-Process "C:\Users\$env:USERNAME\Downloads\parsec-windows.exe" -ArgumentList "/silent", "/shared","/team_id=$team_id","/team_computer_key=$key" -wait
        while (!(Test-Path C:\ProgramData\Parsec\config.txt)) {
            Start-Sleep -s 1
        }
        $configfile  = Get-Content C:\ProgramData\Parsec\config.txt
        $configfile += "host_virtual_monitors = 1"
        $configfile += "host_privacy_mode = 1"
        $configfile | Out-File C:\ProgramData\Parsec\config.txt -Encoding ascii
        Copy-Item -Path "C:\ProgramData\Easy-GPU-P\Parsec.lnk" -Destination "C:\Users\Public\Desktop"
        Stop-Process parsecd -Force
    }
    Set-EasyGPUPScheduledTask -TaskName "Install VB Cable" -Path "%programdata%\Easy-GPU-P\ParsecVDDInstall.ps1" -RunOnce
    Set-EasyGPUPScheduledTask -TaskName "Install Parsec Virtual Display Driver" -Path "%programdata%\Easy-GPU-P\VBCableInstall.ps1" -RunOnce
    Set-EasyGPUPScheduledTask -TaskName "Monitor Parsec VDD State" -Path "%programdata%\Easy-GPU-P\VDDMonitor.ps1"
}

if ($Global:SecondCall -eq $true) {
    Remove-Item C:\Windows\system32\GroupPolicy\User\Scripts\psscripts.ini -Force
    Remove-Item C:\Windows\system32\GroupPolicy\User\Scripts\Logon\nstall.ps1 -Force
    Remove-Item C:\unattend.xml -Force
}
#========================================================================

#========================================================================
function Set-EasyGPUPScheduledTask {
    param (
        [switch]$RunOnce,
        [string]$TaskName,
        [string]$Path
    )
    [xml]$XML = @"
    <?xml version="1.0" encoding="UTF-16"?>
    <Task version="1.2" xmlns="http://schemas.microsoft.com/windows/2004/02/mit/task">
    <RegistrationInfo>
        <Description>$TaskName</Description>
        <URI>\$TaskName</URI>
    </RegistrationInfo>
    <Triggers>
        <LogonTrigger>
        <Enabled>true</Enabled>
        <UserId>$(([System.Security.Principal.WindowsIdentity]::GetCurrent()).Name)</UserId>
        <Delay>PT2M</Delay>
        </LogonTrigger>
    </Triggers>
    <Principals>
        <Principal id="Author">
        <UserId>$(([System.Security.Principal.WindowsIdentity]::GetCurrent()).User.Value)</UserId>
        <LogonType>S4U</LogonType>
        <RunLevel>HighestAvailable</RunLevel>
        </Principal>
    </Principals>
    <Settings>
        <MultipleInstancesPolicy>IgnoreNew</MultipleInstancesPolicy>
        <DisallowStartIfOnBatteries>true</DisallowStartIfOnBatteries>
        <StopIfGoingOnBatteries>true</StopIfGoingOnBatteries>
        <AllowHardTerminate>true</AllowHardTerminate>
        <StartWhenAvailable>false</StartWhenAvailable>
        <RunOnlyIfNetworkAvailable>false</RunOnlyIfNetworkAvailable>
        <IdleSettings>
        <StopOnIdleEnd>true</StopOnIdleEnd>
        <RestartOnIdle>false</RestartOnIdle>
        </IdleSettings>
        <AllowStartOnDemand>true</AllowStartOnDemand>
        <Enabled>true</Enabled>
        <Hidden>false</Hidden>
        <RunOnlyIfIdle>false</RunOnlyIfIdle>
        <WakeToRun>false</WakeToRun>
        <ExecutionTimeLimit>PT72H</ExecutionTimeLimit>
        <Priority>7</Priority>
    </Settings>
    <Actions Context="Author">
        <Exec>
        <Command>C:\WINDOWS\system32\WindowsPowerShell\v1.0\powershell.exe</Command>
        <Arguments>-file $Path</Arguments>
        </Exec>
    </Actions>
    </Task>
"@
    try {
        Get-ScheduledTask -TaskName $TaskName
        if ($RunOnce -eq $true) {
            Unregister-ScheduledTask -TaskName "$TaskName" -Confirm:$false
        }
        $Global:SecondCall = $true
    } catch {
        New-ScheduledTaskAction -Execute 'C:\WINDOWS\system32\WindowsPowerShell\v1.0\powershell.exe' -Argument "-file $Path" | Out-Null
        Register-ScheduledTask -XML $XML -TaskName $TaskName | Out-Null
    }
    Start-ScheduledTask -TaskName $TaskName
}
#========================================================================