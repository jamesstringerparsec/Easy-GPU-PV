Function Get-DesktopPC
{
 $isDesktop = $true
 if(Get-WmiObject -Class win32_systemenclosure | Where-Object { $_.chassistypes -eq 9 -or $_.chassistypes -eq 10 -or $_.chassistypes -eq 14})
   {
   Write-Warning "Computer is a laptop. Laptop internal GPU's partitioned and assigned to VM may not work with Parsec." 
   Write-Warning "Thunderbolt 3 or 4 dock based GPU's may work"
   $isDesktop = $false }
 if (Get-WmiObject -Class win32_battery)
   { $isDesktop = $false }
 $isDesktop
}

Function Get-WindowsCompatibleOS {
$build = Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion'
if ($build.CurrentBuild -ge 22000 -and ($($build.editionid -like 'Professional*') -or $($build.editionid -like 'Enterprise*'))) {
    Return $true
    }
Else {
    Return $false
    }
}


Function Get-HyperVEnabled {
if (Get-WindowsOptionalFeature -Online | Where-Object FeatureName -Like 'Microsoft-Hyper-V-All'){
    Return $true
    }
Else {
    Return $false
    }
}

Function Get-WSLEnabled {
    if ((wsl -l -v)[2].length -gt 1 ) {
        Write-Warning "WSL is Enabled. This may interferre with GPU-P and produce an error 43 in the VM"
        Return $true
        }
    Else {
        Return $false
        }
}

