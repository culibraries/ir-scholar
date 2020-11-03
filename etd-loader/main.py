import sys,os
import glob
import zipfile
from os import path
from zipfile import BadZipfile
from pathlib import Path
from tocsv import tocsv


if __name__ == "__main__":

    source = sys.argv[1]
    destination = sys.argv[2]
    os.chdir(source)


    for zipFile in glob.glob("*.zip"):
        print('runnn')
        Path(destination + Path(zipFile).stem).mkdir(parents=True, exist_ok=True)
        try:
            with zipfile.ZipFile(zipFile, "r") as zip_ref:
                print(Path(zipFile).stem)
                # if path.isdir(destination + Path(zipFile).stem):
                zip_ref.extractall(destination + Path(zipFile).stem)
                tocsv(destination + Path(zipFile).stem, Path(zipFile).stem.split('_')[-1])

        except BadZipfile:
            print("Bad Zipfile: " + Path(zipFile).stem)
            pass
