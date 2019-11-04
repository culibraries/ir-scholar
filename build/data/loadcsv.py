import requests
import json


api_url = "https://libapps.colorado.edu/api/catalog/data/catalog/cuscholar-final.json?query={%22filter%22:{%22document_type%22:%22dissertation%22}}"
# base_url="http://localhost:3000"      #/concern/graduate_thesis_or_dissertations/new"
headers = {'Content-Type': 'application/json'}


def transform():
    pass


def loadItems(work_type="graduate_thesis_or_dissertations"):
    # login()
    req = requests.get(api_url)
    data = req.json()
    for itm in data['results'][:20]:
        print(itm)
