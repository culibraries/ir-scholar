import glob
import os
import zipfile
from pathlib import Path

#NOTE: process happen one by one
def unzip(source, destination):
    os.chdir(source)
    for zipFile in glob.glob("*.zip"):
        os.mkdir(destination + Path(zipFile).stem)
        with zipfile.ZipFile(zipFile, "r") as zip_ref:
            zip_ref.printdir()
            zip_ref.extractall(destination + Path(zipFile).stem)