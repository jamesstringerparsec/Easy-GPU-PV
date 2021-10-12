while(!(Test-NetConnection Google.com).PingSucceeded){
    Start-Sleep -Seconds 1
    }

if (Test-Path HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Parsec) 
    {}
    else {
    (New-Object System.Net.WebClient).DownloadFile("https://builds.parsecgaming.com/package/parsec-windows.exe", "C:\Users\$env:USERNAME\Downloads\parsec-windows.exe")
    (New-Object System.Net.WebClient).DownloadFile("https://builds.parsec.app/vdd/parsec-vdd-0.37.0.0.exe", "C:\Users\$env:USERNAME\Downloads\parsec-vdd.exe")
    Start-Process "C:\Users\$env:USERNAME\Downloads\parsec-windows.exe" -ArgumentList "/silent", "/shared" -wait
    Import-Certificate -CertStoreLocation Cert:\LocalMachine\TrustedPublisher -FilePath "C:\ProgramData\Easy-GPU-P\parsecpublic.cer" | Out-Null
    Start-Process "C:\Users\$env:USERNAME\Downloads\parsec-vdd.exe" -ArgumentList "/silent" -wait
    $configfile = Get-Content C:\ProgramData\Parsec\config.txt
    $configfile += "host_virtual_monitors = 1"
    $configfile += "host_privacy_mode = 1"
    $configfile | Out-File C:\ProgramData\Parsec\config.txt -Encoding ascii
    Stop-Process Parsec -Force
    }

