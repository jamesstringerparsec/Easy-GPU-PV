while(!(Test-NetConnection Google.com).PingSucceeded){
    Start-Sleep -Seconds 1
    }

if (Test-Path HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Parsec) 
    {}
    else {
    (New-Object System.Net.WebClient).DownloadFile("https://builds.parsecgaming.com/package/parsec-windows.exe", "C:\Users\$env:USERNAME\Downloads\parsec-windows.exe")
    (New-Object System.Net.WebClient).DownloadFile("https://builds.parsec.app/vdd/parsec-vdd-0.37.0.0.exe", "C:\Users\$env:USERNAME\Downloads\parsec-vdd.exe")
    Start-Process "C:\Users\$env:USERNAME\Downloads\parsec-windows.exe" -ArgumentList "/silent", "/shared" -wait
    $Success = $false
    [int]$Retries = 0
    do {
        try {
            Import-Certificate -CertStoreLocation Cert:\LocalMachine\TrustedPublisher -FilePath "C:\ProgramData\Easy-GPU-P\parsecpublic.cer"
            $Success = $true
            }
        catch {
            if ($Retries -gt 9){
                $Success = $true
                }
        else {
            Start-Sleep -Seconds 5
            $Retries++
            }
        }
    }
    While ($Success -eq $false)
    Start-Process "C:\Users\$env:USERNAME\Downloads\parsec-vdd.exe" -ArgumentList "/silent" -wait
    $configfile = Get-Content C:\ProgramData\Parsec\config.txt
    $configfile += "host_virtual_monitors = 1"
    $configfile += "host_privacy_mode = 1"
    $configfile | Out-File C:\ProgramData\Parsec\config.txt -Encoding ascii
    Stop-Process Parsec -Force
    }

    $Stoploop = $false
[int]$Retrycount = "0"
 


do {
try {

Write-Host "Job completed"
$Stoploop = $true
}
catch {
if ($Retrycount -gt 3){
Write-Host "Could not send Information after 3 retrys."
$Stoploop = $true
}
else {
Write-Host "Could not send Information retrying in 30 seconds..."
Start-Sleep -Seconds 30
$Retrycount = $Retrycount + 1
}
}
}
While ($Stoploop -eq $false)