$Global:VDD

Function GetVDDState {
$Global:VDD = Get-PnpDevice | where {$_.friendlyname -like "Parsec Virtual Display Adapter"}
}

While (1 -gt 0) {
    GetVDDSTate
    If ($Global:VDD -eq $NULL){
        Start-Sleep -s 10
        }
    If (!((Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\WUDF\Services\ParsecVDA\Parameters\').PSObject.Properties.Name -contains "PreferredRenderAdapterVendorId")) {
        New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\WUDF\Services\ParsecVDA\Parameters\' -Name PreferredRenderAdapterVendorId -PropertyType DWORD -Value 5140 | Out-Null
        Disable-PnpDevice -InstanceId $Global:VDD.InstanceId -Confirm:$false
        }
    Do {
        Enable-PnpDevice -InstanceId $Global:VDD.InstanceId -Confirm:$false
        Start-Sleep -s 5
        GetVDDState
        }
    Until ($Global:VDD.Status -eq 'OK')
    Start-Sleep -s 10
}
