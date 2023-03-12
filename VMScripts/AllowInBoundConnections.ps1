#========================================================================
if ((Get-NetFirewallProfile -Profile Domain).DefaultInboundAction -ne 'Allow') {
	Set-NetFirewallProfile -Profile Domain -DefaultInboundAction 'Allow'
}
if ((Get-NetFirewallProfile -Profile Private).DefaultInboundAction -ne 'Allow') {
	Set-NetFirewallProfile -Profile Private -DefaultInboundAction 'Allow'
}
if ((Get-NetFirewallProfile -Profile Public).DefaultInboundAction -ne 'Allow') {
	Set-NetFirewallProfile -Profile Public -DefaultInboundAction 'Allow'
}
#========================================================================