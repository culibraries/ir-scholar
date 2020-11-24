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
    trunk_number = int(sys.argv[3])
    os.chdir(source)
    count = 0
    for zipFile in glob.glob("*.zip"):
        count = count + 1
        if count == trunk_number+1:
            break
        Path(destination + Path(zipFile).stem).mkdir(parents=True, exist_ok=True)
        try:
            os.chdir(source)
            with zipfile.ZipFile(zipFile, "r") as zip_ref:
                print('{0}: {1}'.format(count, Path(zipFile).stem))
                print('- Unzipping: {0}'.format(Path(zipFile).stem))
                zip_ref.extractall(destination + Path(zipFile).stem)
                tocsv(destination + Path(zipFile).stem, Path(zipFile).stem.split('_')[-1], Path(zipFile).stem, source + zipFile, source +'rejected')
        except BadZipfile:
            print("Bad Zipfile: " + Path(zipFile).stem)
            os.system('mv ' + source + zipFile + ' ' + source +'rejected')
            print('- Moved to Rejected folder')
