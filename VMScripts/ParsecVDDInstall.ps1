if (!(Get-WmiObject Win32_VideoController | Where-Object name -like "Parsec Virtual Display Adapter")) {
(New-Object System.Net.WebClient).DownloadFile("https://builds.parsec.app/vdd/parsec-vdd-0.41.0.0.exe", "C:\Users\$env:USERNAME\Downloads\parsec-vdd.exe")
while (((Get-ChildItem Cert:\LocalMachine\TrustedPublisher) | Where-Object {$_.Subject -like '*Parsec*'}) -eq $NULL) {
    certutil -Enterprise -Addstore "TrustedPublisher" C:\ProgramData\Easy-GPU-P\ParsecPublic.cer
    Start-Sleep -s 5
    }
Get-PnpDevice | Where-Object {$_.friendlyname -like "Microsoft Hyper-V Video" -and $_.status -eq "OK"} | Disable-PnpDevice -confirm:$false
Start-Process "C:\Users\$env:USERNAME\Downloads\parsec-vdd.exe" -ArgumentList "/s"
}

