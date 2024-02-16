#!/bin/bash

# Fetch the list of all shared folders
shared_folders=$(lpass ls | grep '[Shared]' | awk -F/ '{print $1}' | sort | uniq)

echo "Starting to remove shared folders..."
#Read each shared folder name into the variable 'folder'
while IFS= read -r folder; do
    echo "Removing shared folder: $folder"
    lpass share rm "$folder"
    if [ $? -eq 0 ]; then
        echo "$folder removed successfully."
    else
        echo "Failed to remove $folder."
    fi
done <<< "$shared_folders"
echo "Completed removing shared folders."

