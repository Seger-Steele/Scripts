# ============================================================
# Script: SATBypass.ps1
# Description: Checks all user mailboxes for inbox rules containing "PhishMe" or "Phishing_Training" in their descriptions
#              and logs the findings in the console. 
#             
#              These values are used in Cofense PhishMe email headers when sending a simulated phishing email.
#              This script is used to help identify users who are bypassing the SAT by using these values in their inbox rules.
#
# Author: Seger Steele
#
# Usage: powershell -ExecutionPolicy Bypass -File SATBypass.ps1
#
# Notes: This script requires the Exchange Online PowerShell module.
#        It will connect to Exchange Online and retrieve all user mailboxes.
# ============================================================
# Define the keywords to search for in rule descriptions
$keywords = @("PhishMe", "Phishing_Training")

# Connect to Exchange Online
try {
    Write-Host "Connecting to Exchange Online..." -ForegroundColor Cyan
    Connect-ExchangeOnline -ShowProgress $true
}
catch {
    Write-Error "Failed to connect to Exchange Online. $_" -ForegroundColor Red
    exit 1
}
# Retrieve all user mailboxes
try {
    Write-Host "Retrieving all user mailboxes..." -ForegroundColor Cyan
    $mailboxes = Get-Mailbox -ResultSize Unlimited -RecipientTypeDetails UserMailbox
}
catch {
    Write-Error "Failed to retrieve mailboxes. $_" -ForegroundColor Red
    Disconnect-ExchangeOnline -Confirm:$false
    exit 1
}
# Initialize an array to store alert information
$alerts = @()
# Iterate through each mailbox
foreach ($mailbox in $mailboxes) {
    $mailboxEmail = $mailbox.PrimarySmtpAddress.ToString()
    Write-Host "Processing mailbox: $mailboxEmail" -ForegroundColor Cyan
    try {
        # Retrieve all inbox rules for the current mailbox
        $rules = Get-InboxRule -Mailbox $mailboxEmail
    }
    catch {
        Write-Warning "Unable to retrieve inbox rules for $mailboxEmail. Skipping. Error: $_"
        continue
    }
    # Check each rule's description for the specified keywords
    foreach ($rule in $rules) {
        if ($null -ne $rule.Description) {
            foreach ($keyword in $keywords) {
                if ($rule.Description -like "*$keyword*") {
                    # Sanitize the Description to be single-line by replacing newlines and tabs with spaces
                    $sanitizedDescription = ($rule.Description -replace "(\r\n|\n|\r|\t)", " ").Trim()
                    # Add the alert to the array with sanitized description
                    $alerts += [PSCustomObject]@{
                        Mailbox     = $mailboxEmail
                        RuleName    = $rule.Name
                        Description = $sanitizedDescription
                    }
                    Write-Host "  ➔ Alert: Rule '$($rule.Name)' in mailbox '$mailboxEmail' contains keyword '$keyword'." -ForegroundColor Red
                    break
                }
            }
        }
    }
}
# Disconnect the Exchange Online session
Disconnect-ExchangeOnline -Confirm:$false
Write-Host "Disconnected from Exchange Online." -ForegroundColor Cyan
# Output the alerts
if ($alerts.Count -gt 0) {
    Write-Host "`nSAT Bypass inbox rules found:" -ForegroundColor Green
    $alerts | Format-Table -AutoSize
}
else {
    Write-Host "`nNo SAT Bypass inbox rules found." -ForegroundColor Green
}