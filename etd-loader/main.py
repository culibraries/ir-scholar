import sys
from unzip import unzip
from tocsv import tocsv
import os

if __name__ == "__main__":

    print("==== Unzipping... =====")
    source = sys.argv[1]
    destination = sys.argv[2]
    unzip(source, destination)
    print("==== Done... =====")
    print("===")
    print("===")
    print("===")
    #NOTE: catch exception for each step
    #NOTE: move to error folder with error log (.error)

    print("==== Converting to CSV format...===")
    tocsv(source)
    print("==== Done...===")
    print("===")
    print("===")
    print("===")

    print("==== Load CSV to IR...===")
    # os.system('ruby toir.rb')
    print("==== Done...===")
