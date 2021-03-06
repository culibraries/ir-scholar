import csv
import requests
import json
import re
import logging
from bs4 import BeautifulSoup
from six.moves.html_parser import HTMLParser
from functools import reduce
from datetime import datetime
from dateutil.parser import parse

now = datetime.now().isoformat().replace(':', '').split('.')[0]
academic_affiliation_file = "academicAffiliationMap.csv"
csvfile = open(academic_affiliation_file, 'r')
academicMap = [{k: v for k, v in row.items()} for row in csv.DictReader(
    csvfile, delimiter='|', skipinitialspace=True)]
csvfile.close()
api_url = 'https://libapps.colorado.edu/api/catalog/data/catalog/cuscholar-final-2019-12-20.json?query={"filter":{"context_key":"9346274","samvera_url":{"$exists":true}}}'
#api_url = 'https://libapps.colorado.edu/api/catalog/data/catalog/cuscholar-final-2019-12-20.json?query={"filter":{"samvera_url":{"$exists":false},"document_type":"thesis"}}&page_size=0'
#api_url = 'https://libapps.colorado.edu/api/catalog/data/catalog/cuscholar-final.json?query={"filter":{"document_type":"thesis"}}&page_size=0'

# old
#api_url = 'https://libapps.colorado.edu/api/catalog/data/catalog/cuscholar.json?query={"filter":{"document_type":"dissertation"}}&page_size=0'
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
            'admin_set_id': 'k643b116n',
            'visibility': 'open',
            'resource type': 'Masters Thesis',
            'degree_level': "Master's",
            'degree_grantors': 'http://id.loc.gov/authorities/names/n50000485'
            }

# resource type, Rights Statement, date created,
# Test
# 'admin_set_id':'qb98mf449',
# PRod
# 'admin_set_id': 'k643b116n',


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
        if tmp:
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


def additonal_information(itm):
    if itm['source_publication'].strip() and itm['comments'].strip():
        value = "{0} - {1}".format(clean_abstract_text(
            itm['comments']), itm['source_publication'])
    elif itm['comments'].strip():
        value = "{0}".format(clean_abstract_text(itm['comments']))
    elif itm['source_publication'].strip():
        value = "{0}".format(itm['source_publication'])
    else:
        value = ''
    return value


def academicAffiliation(itm):
    #csvfile = open(academic_affiliation_file,'r')
    #amap = [{k: v for k, v in row.items()} for row in csv.DictReader(csvfile,delimiter='|', skipinitialspace=True)]
    academicMap
    match = itm['front_end_url'].split('/')[-2]
    for aa in academicMap:
        if aa['bepress'] == match:
            return aa['samvera']
    return 'Other'


def pubDateFormat(itm):
    try:
        mydate = parse(itm["publication_date"])
        value = mydate.strftime("%Y-%m-%d")
        if value[4:] == "-01-01":
            value = mydate.year
    except:
        value = "9999"
    return value


def graduationYear(itm):
    try:
        mydate = parse(itm["publication_date"])
        value = mydate.year  # .strftime("%Y-%m-%d")
    except:
        value = "9999"
    return value


def replaces(itm):
    return "{0}|{1}".format(itm['context_key'], itm['front_end_url'])


def transform(itm):
    data_row = dict.fromkeys(csv_headers, '')
    data_row.update(defaults)
    data_row['title'] = itm['title']

    data_row['creator'] = clean_format_name(
        itm['authors'], divider=csv_divider)
    if itm['advisors']:
        data_row['contributor_advisor'] = clean_format_name(
            ",".join(itm['advisors'][:1]), divider=csv_divider)
    else:
        data_row['contributor_advisor'] = ''
    if len(itm['advisors']) > 1:
        data_row['contributor_committeemember'] = clean_format_name(
            ",".join(itm['advisors'][1:]), divider=csv_divider)
    else:
        data_row['contributor_committeemember'] = ''
    data_row['abstract'] = clean_abstract_text(itm['abstract'])
    #data_row['date created'] = itm['publication_date'].split(' ')[0]
    #data_row['date_created'] = itm['publication_date'].split(' ')[0]
    data_row['subject'] = csv_divider.join(itm['keywords'])
    data_row['keyword'] = csv_divider.join(itm['keywords'])
    if not data_row['keyword']:
        data_row['keyword'] = 'keyword'
    data_row['academic_affiliation'] = academicAffiliation(itm)
    data_row['graduation_year'] = graduationYear(itm)
    data_row['license'] = itm['distribution_license']
    data_row['publisher'] = itm["publisher"]
    data_row['identifier'] = itm['identifier']
    data_row['related url'] = itm['url']
    #data_row['date_available'] = itm["publication_date"].split(' ')[0]
    # itm["publication_date"].split('-')[0]
    data_row['date_issued'] = pubDateFormat(itm)
    data_row['doi'] = itm['doi']
    data_row['degree_name'] = itm['degree_name']
    data_row['peerreviewed'] = itm['peer_reviewed']
    data_row['replaces'] = replaces(itm)
    data_row['bibliographic_citation'] = itm['custom_citation']
    data_row['additional_information'] = additonal_information(itm)
    try:
        #data_row['files'] = 'ableToDownload.pdf'
        data_row['files'] = getFiles(itm)
    except UnableToDownload:
        data_row['files'] = 'unableToDownload.pdf'
    return data_row


def writeCsvFile(csv_data, error_data, count):
    now = datetime.now().isoformat().replace(':', '').split('.')[0]
    keys = csv_data[0].keys()
    with open('csv_output/{0}_{1}_dataload_{2}.csv'.format(now, defaults['resource type'].replace(' ', '_').lower(), count), 'w') as output_file:
        dict_writer = csv.DictWriter(output_file, keys)
        dict_writer.writeheader()
        dict_writer.writerows(csv_data)
    if error_data:
        with open('csv_output/{0}_{1}_error_{2}.json'.format(now, defaults['resource type'].replace(' ', '_').lower(), count), 'w') as output_file:
            output_file.write(json.dumps(error_data, indent=4))


def loadItems(work_type="graduate_thesis_or_dissertations"):
    # login()
    req = requests.get(api_url)
    data = req.json()
    csv_data = []
    error_data = []
    count = 0
    undercount = 0
    undergrad = ['honr_theses', 'advert_ugrad',
                 'comm_ugrad', 'journ_ugrad', 'media_ugrad']
    for itm in data['results']:
        if itm['front_end_url'].split('/')[-2] in undergrad:
            undercount += 1
        else:
            try:
                #data = transform(itm)
                csv_data.append(transform(itm))
                # print(itm)
            except Exception as e:
                print(e)
                logging.error('Error at %s', 'division', exc_info=e)
                error_data.append(itm)
            count += 1
            if (count % 250 == 0 and count != 0):
                writeCsvFile(csv_data, error_data, count)
                csv_data = []
                error_data = []
    # Write remaining csv if data
    if csv_data or error_data:
        writeCsvFile(csv_data, error_data, count)
    print("Undergrad:", undercount)


if __name__ == "__main__":
    loadItems()
