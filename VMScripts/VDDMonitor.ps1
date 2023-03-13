#========================================================================
While ($true) {
    $VDD = Get-PnpDevice | where {$_.friendlyname -like "Parsec Virtual Display Adapter"}
    if (($VDD -eq $NULL) -or ($VDD.Status -eq 'OK')){
        exit
    } 
    Enable-PnpDevice -InstanceId $VDD.InstanceId -Confirm:$false
    Start-Sleep -s 5
}
#========================================================================