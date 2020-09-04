import sys
from unzip import unzip
from tocsv import tocsv
if __name__ == "__main__":

    # print("==== Unzipping... =====")
    source = sys.argv[1]
    # destination = sys.argv[2]
    # unzip(source, destination)
    # print("==== Done... =====")

    print("==== Converting to CSV format...===")
    tocsv(source)
    print("==== Done...===")