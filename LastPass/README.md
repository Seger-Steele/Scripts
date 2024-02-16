# Shared Folder Removal Script

This script is used to remove all shared folders from your LastPass account.  When you migrate off LastPass to a different password manager, LastPass puts the data deletion onto the consumer.  If you don't delete all your data (including shared folders and accounts) then all corp users are converted into personal accounts and take their corp data into those personal acccounts where there is no security governance. 

## Prerequisites

- LastPass CLI: This script uses the LastPass CLI (`lpass`). Make sure it's installed and you're logged in.
- You can login prior to using this script, with "lpass login test@acme.org". 

## How It Works

1. The script first fetches the list of all shared folders in your LastPass account.
2. It then starts to remove each shared folder one by one.
3. For each folder, it prints a message indicating the start of the removal process.
4. It then attempts to remove the folder using the `lpass share rm` command.
5. If the removal is successful, it prints a success message. Otherwise, it prints a failure message.
6. This process is repeated for all shared folders.
7. Finally, it prints a message indicating the completion of the removal process.

## Caution 

This script will remove all shared folders from your LastPass account.
