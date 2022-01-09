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
  