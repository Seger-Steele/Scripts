# Description: Searches for any forwarding domain that contain a string of your choosing (supports wildcards, or entire addresses) and disables forwarding to those addresses.
# Use Case: Needing to turn off SMTP forwarding but only to certain domains or certain email addresses. 
#           If the string you enter for -like is in any part of the forwarding address this script will
#           remove the autoforwarding by setting the value to $null.
#
#           It also is a control of the CIS M365 Foundations Benchmark(this is where you can get a list of users that are forwarding mail):
#           - https://security.microsoft.com/exposure-recommendations?recommendationId=mdo_blockmailforward
#
# Author: Seger Steele
# Usage: powershell -ExecutionPolicy Bypass -File DisableMailForwarding.ps1
#
# Notes: This script requires the Exchange Online PowerShell module.
#        It will connect to Exchange Online and retrieve all user mailboxes.

# Connect to Exchange Online
try {
    Write-Host "Connecting to Exchange Online..." -ForegroundColor Cyan
    Connect-ExchangeOnline -ShowProgress $true
}
catch {
    Write-Error "Failed to connect to Exchange Online. $_" -ForegroundColor Red
    exit 1
}
$mailboxes = Get-Mailbox | Where-Object { $_.ForwardingSMTPAddress -ne $null -and $_.ForwardingSMTPAddress -like "*personalmail@gmail.com*" }
foreach ($mailbox in $mailboxes) {
    Set-Mailbox -Identity $mailbox.UserPrincipalName -ForwardingSMTPAddress $null
    Write-Output "Forwarding removed for: $($mailbox.UserPrincipalName)"
}
