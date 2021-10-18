<#
if (!(Test-Path C:\ProgramData\Easy-GPU-P\second.txt)) {
    exit
    }
else {
    if( !((Get-ChildItem -Path Cert:\CurrentUser\TrustedPublisher).DnsNameList.Unicode -like "Parsec Cloud, Inc.")) {
    $Success = $false
    [int]$Retries = 0
    do {
        try {
            Import-Certificate -CertStoreLocation Cert:\CurrentUser\TrustedPublisher -FilePath C:\ProgramData\Easy-GPU-P\parsecpublic.cer
            $Success = $true
            }
        catch {
            if ($Retries -gt 60){
                $Success = $true
                }
            else {
                Start-Sleep -Seconds 1
                $Error[0] |Out-File C:\ProgramData\Easy-GPU-P\log.txt
                $env:USERNAME | Out-File C:\ProgramData\Easy-GPU-P\username.txt
                $Retries++
    
                }
        }
    }
    While ($Success -eq $false)

    }
    Else {
    }
    }
#>