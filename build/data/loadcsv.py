import csv
import requests
import json
import re
from bs4 import BeautifulSoup
from six.moves.html_parser import HTMLParser
from functools import reduce
from datetime import datetime

now = datetime.now().isoformat().replace(':', '').split('.')[0]
academic_affiliation_file = "academicAffiliationMap.csv"
csvfile = open(academic_affiliation_file, 'r')
academicMap = [{k: v for k, v in row.items()} for row in csv.DictReader(
    csvfile, delimiter='|', skipinitialspace=True)]
csvfile.close()

api_url = 'https://libapps.colorado.edu/api/catalog/data/catalog/cuscholar-final.json?query={"filter":{"document_type":"dissertation","abstract":{"$regex":"<sup>"}}}'
# base_url="http://localhost:3000"      #/concern/graduate_thesis_or_dissertations/new"
headers = {'Content-Type': 'application/json'}
csv_divider = "|~|"
# 'description','date_created',

csv_headers = ['title', 'date created', 'resource type', 'creator', 'contributor', 'keyword', 'license', 'rights statement', 'publisher',
               'subject', 'language', 'identifier', 'location', 'related_url', 'bibliographic_citation', 'source', 'abstract', 'academic_affiliation',
               'additional_information', 'alt_title', 'contributor_advisor', 'contributor_committeemember', 'date_available', 'date_issued', 'degree_grantors',
               'degree_level', 'doi', 'embargo_reason', 'graduation_year', 'peerreviewed', 'replaces', 'language', 'admin_set_id', 'visibility', 'files']
defaults = {'language': 'http://id.loc.gov/vocabulary/iso639-2/eng',
            'rights statement': 'http://rightsstatements.org/vocab/InC/1.0/',
            'degree_grantors': 'http://id.loc.gov/authorities/names/n50000485',
            'admin_set_id': 'qb98mf449',
            'visibility': 'open',
            'resource type': 'Dissertation',
            'degree_level': 'Doctoral',
            'degree_grantors': 'http://id.loc.gov/authorities/names/n50000485'
            }

# resource type, Rights Statement, date created,


class Error(Exception):
    """Base class for other exceptions"""
    pass


class UnableToDownload(Error):
    """Raised when unable to download"""
    pass


def deep_get(_dict, keys, default=None):
    """
    Deep get on python dictionary. Key is in dot notation.
    Returns value if found. Default returned if not found.
    Default can be set to another deep_get function.
    """
    keys = keys.split('.')

    def _reducer(d, key):
        if isinstance(d, dict):
            return d.get(key, default)
        return default
    return reduce(_reducer, keys, _dict)


def clean_format_name(names, divider="|~|"):
    names = re.sub(', and ', ',', names, re.IGNORECASE)
    names = re.sub(' and ', ',', names, re.IGNORECASE)
    newName = []
    for name in names.split(','):
        tmp = name.split(" ")
        try:
            tmp.remove('')
        except:
            pass
        newName.append("{0}, {1}".format(tmp[-1], " ".join(tmp[:-1])))
    return divider.join(newName)


def super_sub_script_replace(text, start_tag, stop_tag):
    starts = [m.start() for m in re.finditer(start_tag, text)]
    stops = [m.start() for m in re.finditer(stop_tag, text)]
    SUBnumeric = str.maketrans("0123456789", "₀₁₂₃₄₅₆₇₈₉")
    SUBalhpa = str.maketrans("abcdeijoqruvwxyzAEIJORUVX-+",
                             "ₐᵦ𝒸𝒹ₑᵢⱼₒᵩᵣᵤᵥ𝓌ₓᵧ𝓏ₐₑᵢⱼₒᵣᵤᵥₓ₋₊")
    SUPnumeric = str.maketrans("0123456789", "⁰¹²³⁴⁵⁶⁷⁸⁹")
    SUPalhpa = str.maketrans("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ-+",
                             "ᵃᵇᶜᵈᵉᶠᵍʰᶦʲᵏˡᵐⁿᵒᵖᑫʳˢᵗᵘᵛʷˣʸᶻᴬᴮᶜᴰᴱᶠᴳᴴᴵᴶᴷᴸᴹᴺᴼᴾQᴿˢᵀᵁⱽᵂˣʸᶻ⁻⁺")
    #print(starts, stops)
    # print(tag)
    search_replace = []
    for idx, itm in enumerate(starts, start=0):
        #print(starts, stops)
        if itm:
            soup = BeautifulSoup(text[itm:stops[idx]+6], 'html.parser')
            tmp = soup.get_text()
            if start_tag == '<sub>':
                tmp = tmp.translate(SUBnumeric)
                tmp = tmp.translate(SUBalhpa)
                search_replace.append((text[itm:stops[idx]+6], tmp))
            else:
                tmp = tmp.translate(SUPnumeric)
                tmp = tmp.translate(SUPalhpa)
                search_replace.append((text[itm:stops[idx]+6], tmp))
    for sr in search_replace:
        text = text.replace(sr[0], sr[1])
    # print(search_replace)
    return text


def clean_abstract_text(html):
    # Super and Sub scripts insertion
    text = super_sub_script_replace(html, '<sub>', '</sub>')
    text = super_sub_script_replace(text, '<sup>', '</sup>')
    # Translate special characters
    h = HTMLParser()
    text = h.unescape(text)
    # Remove all tags remaining
    soup = BeautifulSoup(text, 'html.parser')
    text = soup.get_text()
    return text


def getFiles(itm):
    files = []
    main_file = deep_get(itm, 'data_files.s3.processed.key', default=None)
    if main_file.strip():
        files.append(
            deep_get(itm, 'data_files.s3.processed.key', default=None))
    elif main_file.strip() == "":
        raise UnableToDownload
    else:
        raise

    alt_file = deep_get(
        itm, 'data_files.s3.processed.additional_files', default=[])
    alt_file = list(set(alt_file))
    return csv_divider.join(files + alt_file)


def academicAffiliation(itm):
    #csvfile = open(academic_affiliation_file,'r')
    #amap = [{k: v for k, v in row.items()} for row in csv.DictReader(csvfile,delimiter='|', skipinitialspace=True)]
    academicMap
    match = itm['front_end_url'].split('/')[-2]
    for aa in academicMap:
        if aa['bepress'] == match:
            return aa['samvera']
    return 'Other'


def graduationYear(itm):
    year = itm["publication_date"].split('-')[0]
    if not year:
        return '9999'
    return year


def replaces(itm):
    return "{0}|{1}".format(itm['context_key'], itm['front_end_url'])


def transform(itm):
    data_row = dict.fromkeys(csv_headers, '')
    data_row.update(defaults)
    data_row['title'] = itm['title']
    data_row['creator'] = clean_format_name(
        itm['authors'], divider=csv_divider)
    data_row['contributor_advisor'] = clean_format_name(
        ",".join(itm['advisors'][:1]), divider=csv_divider)
    data_row['contributor_committeemember'] = clean_format_name(
        ",".join(itm['advisors'][1:]), divider=csv_divider)
    data_row['abstract'] = clean_abstract_text(itm['abstract'])
    #data_row['date created'] = itm['publication_date'].split(' ')[0]
    #data_row['date_created'] = itm['publication_date'].split(' ')[0]
    data_row['subject'] = csv_divider.join(itm['keywords'])
    data_row['keyword'] = csv_divider.join(itm['keywords'])
    data_row['academic_affiliation'] = academicAffiliation(itm)
    data_row['graduation_year'] = graduationYear(itm)
    data_row['license'] = itm['distribution_license']
    data_row['publisher'] = itm["publisher"]
    data_row['identifier'] = itm['identifier']
    data_row['related url'] = itm['url']
    #data_row['date_available'] = itm["publication_date"].split(' ')[0]
    data_row['date_issued'] = itm["publication_date"].split(' ')[0]
    data_row['doi'] = itm['doi']
    data_row['degree_name'] = itm['degree_name']
    data_row['peerreviewed'] = itm['peer_reviewed']
    data_row['replaces'] = replaces(itm)
    try:
        data_row['files'] = 'ableToDownload.pdf'
        #data_row['files'] = getFiles(itm)
    except UnableToDownload:
        data_row['files'] = 'unableToDownload.pdf'
    return data_row


def loadItems(work_type="graduate_thesis_or_dissertations"):
    # login()
    req = requests.get(api_url)
    data = req.json()
    csv_data = []
    error_data = []
    for itm in data['results'][10:13]:
        try:
            #data = transform(itm)
            csv_data.append(transform(itm))
            print(itm)
        except:
            error_data.append(itm)
    keys = csv_data[0].keys()
    now = datetime.now().isoformat().replace(':', '').split('.')[0]
    with open('{0}_{1}_dataload.csv'.format(now, defaults['resource type'].lower()), 'w') as output_file:
        dict_writer = csv.DictWriter(output_file, keys)
        dict_writer.writeheader()
        dict_writer.writerows(csv_data)
    if error_data:
        with open('{0}_{1}_error.json'.format(now, defaults['resource type'].lower()), 'w') as output_file:
            output_file.wrie(json.dumps(error_data, indent=4))


if __name__ == "__main__":
    loadItems()
