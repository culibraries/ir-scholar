import glob
import xmltodict
import sys
import os
files = [
'etdadmin_upload_121853',
'etdadmin_upload_250013']

for file in files:
      for filepath in glob.glob('/efs/prod/proquest/processing_folder/'+file+'/*.xml', recursive=True):
            with open(filepath, encoding="ISO-8859-1") as fd:
                  #print('https://s3-us-west-2.amazonaws.com/cubl-static/samvera/metadata/' + os.path.basename(filepath))
                  itm = xmltodict.parse(fd.read(), process_namespaces=True)['DISS_submission']['DISS_description']['DISS_title']
                  print(itm)