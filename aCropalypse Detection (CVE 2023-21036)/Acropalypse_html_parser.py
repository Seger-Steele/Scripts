# Script to detect Acropalyspe (CVE-2023-21036)
# This will assume you have the html files downloaded locally in the current working directory


import os
import shutil
from bs4 import BeautifulSoup


def save_images_from_html(html_file, destination_folder, verbose=False, dry_run=False):
    with open(html_file, 'r') as file:
        soup = BeautifulSoup(file, 'html.parser')

    img_tags = soup.find_all('img')
    for img_tag in img_tags:
        image_src = img_tag.get('src')
        image_file = os.path.join(os.path.dirname(html_file), image_src)

        if os.path.isfile(image_file):
            if dry_run is False:
                shutil.copy(image_file, destination_folder)
            if verbose is True or dry_run is True:
                print(f"Image '{image_file}' copied to '{destination_folder}'")
        else:
            if verbose is True or dry_run is True:
                print(f"Image '{image_file}' not found")


def process_html_files(html_folder, destination_folder, verbose=False, dry_run=False):
    if verbose is True:
        print(f"Working in dir: {html_folder}")
    for root, _, files in os.walk(html_folder):
        for file in files:
            if file.endswith(".html"):
                html_file_path = os.path.join(root, file)
                if verbose is True:
                    print(f"Processing file: {html_file_path}")
                save_images_from_html(
                    html_file_path, destination_folder, verbose, dry_run)


if __name__ == '__main__':
    import argparse
    parser = argparse.ArgumentParser(
        'Script to detect Acropalyspe (CVE-2023-21036)', add_help=False)
    required = parser.add_argument_group('Required')
    required.add_argument('-i', '--input', required=True,
                          help='Directory path of the html files')
    required.add_argument('-o', '--output', required=True,
                          help='Directory path of where the images will be saved')
    optional = parser.add_argument_group('Optional')
    optional.add_argument(
        '-v', '--verbose', action='store_true', default=False, help='Print verbose output')
    optional.add_argument(
        '-h', '--help', action='help', help='Prints this message')
    optional.add_argument('-d', '--dry-run', action='store_true',
                          default=False, help='Dry run... because it makes sense')
    args = parser.parse_args()

    process_html_files(args.input, args.output,
                       args.verbose, args.dry_run)
