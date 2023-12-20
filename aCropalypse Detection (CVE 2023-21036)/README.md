#DISCLAIMER: I Created, acrop, acropalypse_detection.py was copied from https://github.com/infobyte/CVE-2023-21036, this will tell you if the files are vulnerable or not.

Acropalypse.py will do a few things:
1. Search the specified directory for html files
2. Parse every image (jpg, png, jpeg, gif) out of the html files within the specified directory
3. Save these image files to a new sopecified directory

Requires that you:

 - Have the html files downloaded locally all under 1 directory
 - Update the variables at the end of the script (html_folder and destination_folder).  These are highlighed by edits within the script.
 

acropalypse_detection.py was copied from https://github.com/infobyte/CVE-2023-21036, this will tell you if the files are vulnerable or not.  See the link for more details. 

Requires that you: 
1. Using the script from link (modified) update the path location

for i in Images\ from\ UM/*; do
  python3 acropalypse_detection.py "$i"
done

  
