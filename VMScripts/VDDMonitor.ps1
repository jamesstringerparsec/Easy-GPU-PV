#========================================================================
$Global:VDD
#========================================================================

#========================================================================
function GetVDDState {
    $Global:VDD = Get-PnpDevice | where {$_.friendlyname -like "Parsec Virtual Display Adapter"}
}
#========================================================================

#========================================================================
While (1 -gt 0) {
    GetVDDSTate
    if ($Global:VDD -eq $NULL){
        exit
    } 
    do {
        Enable-PnpDevice -InstanceId $Global:VDD.InstanceId -Confirm:$false
        Start-Sleep -s 5
        GetVDDState
    } until ($Global:VDD.Status -eq 'OK')
    Start-Sleep -s 10
}
#========================================================================