# input params
# TODO: check these carefully before using this again
output_folder = r"d:\SteamLibrary\steamapps\common\testing_temp"
downloads_folder = r"c:\Users\dbawa\Downloads"

import zipfile
import os

def main():
    # example (testing)
    for item in os.listdir(downloads_folder):
        item_path = os.path.join(downloads_folder, item)
        if os.path.isfile(item_path):
            if item.endswith(".zip"):
                extract_txt_files(item_path, output_folder)


def extract_txt_files(zip_path, output_folder):
    # open zip
    with zipfile.ZipFile(zip_path, "r") as zip_ref:
        for file_info in zip_ref.infolist():
            # also check for standalone .dll files
            if file_info.filename.startswith("BepInEx"):
                zip_ref.extract(file_info.filename, output_folder)

if __name__ == "__main__":
    main()

# open zip folder

# search for either .dll OR BepInEx folder

# if .dll:
#   then move it straight to dest\plugins folder

# if there exists any folder:
#   then for each folder (and/or sub-folder):
#       if its BepInEx:
#           then descend and place .dll in corresponding /folder/*.dll
#       if its other folder:
#           then do not descend and place .dll in corresponding /folder/*.dll
#
