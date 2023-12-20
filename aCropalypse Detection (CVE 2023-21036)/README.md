## DISCLAIMER: I created Acropalypse_html_parser.py; acropalypse_detection.py was copied from https://github.com/infobyte/CVE-2023-21036.

The combo of these 2 scripts are to: 

1. Parse out images from HTML files.
2. Identify any images that are susceptible to Acropalyspe.
<br>
Our use case was to review our employee/product handbooks and several other guides hosted on a online wiki. I downloaded the HTML files from the wiki into 1 directory and used this script to determine our exposure. Any images that are susceptible should be replaced in-case production data was used in the screenshots.

<br>
<br>
<br>

Acropalypse_html_parser.py will do a few things:

- Search the specified directory for html files.
- Parse every image (jpg, png, jpeg, gif) out of the html files within the specified directory.
- Save these image files to a new specified directory.
   <br>
  <br>
  <br>
Requires that you:

- Have the html files downloaded locally all under 1 directory.
- Update the variables at the end of the script (html_folder and destination_folder). These are highlighted by comments within the script.
<br>
<br>
<br>

acropalypse_detection.py was copied from https://github.com/infobyte/CVE-2023-21036, this will tell you if the files are vulnerable or not. See the link for more details.

Requires that you:

- Using the script from link (modified) update the path location.

  
