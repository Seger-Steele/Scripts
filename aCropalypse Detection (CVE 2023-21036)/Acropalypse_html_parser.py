# Script to detect Acropalyspe (CVE-2023-21036)
# This will assume you have the html files downloaded directly 


import os
import shutil
from bs4 import BeautifulSoup

def save_images_from_html(html_file, destination_folder):
    with open(html_file, 'r') as file:
        soup = BeautifulSoup(file, 'html.parser')
    
    img_tags = soup.find_all('img')
    for img_tag in img_tags:
        image_src = img_tag.get('src')
        image_file = os.path.join(os.path.dirname(html_file), image_src)
        
        if os.path.isfile(image_file):
            shutil.copy(image_file, destination_folder)
            print(f"Image '{image_file}' copied to '{destination_folder}'")
        else:
            print(f"Image '{image_file}' not found")

def process_html_files(html_folder, destination_folder):
    for root, _, files in os.walk(html_folder):
        for file in files:
            if file.endswith(".html"):
                html_file_path = os.path.join(root, file)
                save_images_from_html(html_file_path, destination_folder)

# EDIT ME - Directory path of the html files
html_folder = '/Users/segersteele/Desktop/Scripts/Acropalypse/UM'

# EDIT ME - Directory path of where the images will be saved
destination_folder = '/Users/segersteele/Desktop/Scripts/Acropalypse/Images from UM'

process_html_files(html_folder, destination_folder)
