param(
$team_id,
$key
)

while(!(Test-NetConnection Google.com).PingSucceeded){
    Start-Sleep -Seconds 1
    }

if (Test-Path HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Parsec) 
    {}
    else {
    (New-Object System.Net.WebClient).DownloadFile("https://builds.parsecgaming.com/package/parsec-windows.exe", "C:\Users\$env:USERNAME\Downloads\parsec-windows.exe")
    (New-Object System.Net.WebClient).DownloadFile("https://builds.parsec.app/vdd/parsec-vdd-0.37.0.0.exe", "C:\Users\$env:USERNAME\Downloads\parsec-vdd.exe")
    $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator) | Out-File C:\ProgramData\Easy-GPU-P\admim.txt
    Start-Process "C:\Users\$env:USERNAME\Downloads\parsec-windows.exe" -ArgumentList "/silent", "/shared","/team_id=$team_id","/team_computer_key=$key" -wait
    $configfile = Get-Content C:\ProgramData\Parsec\config.txt
    $configfile += "host_virtual_monitors = 1"
    $configfile += "host_privacy_mode = 1"
    $configfile | Out-File C:\ProgramData\Parsec\config.txt -Encoding ascii
    }

<#
    if (!((Get-ChildItem -Path Cert:\CurrentUser\TrustedPublisher).DnsNameList.Unicode -like "Parsec Cloud, Inc.")) {
    cmd /c C:\ProgramFiles\Easy-GPU-P\cert.bat
    }

    Invoke-Item Cert:\CurrentUser\TrustedPublisher
    start-sleep -s 30


if (!((Get-ChildItem -Path Cert:\CurrentUser\TrustedPublisher).DnsNameList.Unicode -like "Parsec Cloud, Inc.")) {
    Import-Certificate -CertStoreLocation Cert:\CurrentUser\TrustedPublisher -FilePath C:\ProgramData\Easy-GPU-P\parsecpublic.cer
if (!(Test-Path C:\ProgramData\Easy-GPU-P\second.txt)) {
    New-Item -ItemType File -Path C:\ProgramData\Easy-GPU-P\second.txt
    Restart-Computer
    }
}
#>

  
#if(((Get-ChildItem -Path Cert:\CurrentUser\TrustedPublisher).DnsNameList.Unicode -like "Parsec Cloud, Inc.")) {
    if (!(Get-WmiObject Win32_VideoController | Where-Object name -like "Parsec Virtual Display Adapter")) {
    cmd /c C:\ProgramFiles\Easy-GPU-P\cert.bat
    Start-Process "C:\Users\$env:USERNAME\Downloads\parsec-vdd.exe" -ArgumentList "/silent"
    }

<#}
Else {
Restart-Computer
}
#>
