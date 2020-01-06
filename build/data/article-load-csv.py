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
import pandas as pd

now = datetime.now().isoformat().replace(':', '').split('.')[0]
academic_affiliation_file = "academicAffiliationMap.csv"
csvfile = open(academic_affiliation_file, 'r')
academicMap = [{k: v for k, v in row.items()} for row in csv.DictReader(
    csvfile, delimiter='|', skipinitialspace=True)]
csvfile.close()

api_url = 'https://libapps.colorado.edu/api/catalog/data/catalog/cuscholar-final-2019-12-20.json?query={%22filter%22:{%22samvera_url%22:{%22$exists%22:false},%22document_type%22:%22article%22}}&page_size=0'
#api_url = 'https://libapps.colorado.edu/api/catalog/data/catalog/cuscholar-final.json?query={"filter":{"document_type":"article"}}&page_size=0'
headers = {'Content-Type': 'application/json'}
csv_divider = "|~|"
# 'description','date_created',

csv_headers = ['title', 'date created', 'resource type', 'creator', 'contributor', 'keyword', 'license', 'rights statement', 'publisher',
               'subject', 'language', 'identifier', 'location', 'related_url', 'bibliographic_citation', 'source', 'abstract', 'academic_affiliation',
               'has_journal', 'has_number', 'has_volume', 'issn', 'editor', 'in_series', 'additional_information', 'alt_title',  'date_available', 'date_issued',
               'doi', 'file_extent', 'file_format', 'embargo_reason', 'peerreviewed', 'replaces', 'language', 'admin_set_id', 'visibility', 'files']

defaults = {'language': 'http://id.loc.gov/vocabulary/iso639-2/eng',
            'rights statement': 'http://rightsstatements.org/vocab/InC/1.0/',
            'admin_set_id': 'nv935286k',
            'visibility': 'open',
            'resource type': 'Article',

            }
# Article Prod nv935286k

# resource type, Rights Statement, date created,
# Test
# 'admin_set_id':'qb98mf449',
# PRod
# 'admin_set_id': 'k643b116n',
# undergrad m326m172d
# test qb98mf449


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
    # print(starts, stops)
    # print(tag)
    search_replace = []
    for idx, itm in enumerate(starts, start=0):
        # print(starts, stops)
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
    # query = '{"filter":{"front_end_url":"' + \
    #     itm['front_end_url'] + '","context_key":"' + itm['context_key'] + '"}}'
    # url = 'https://libapps.colorado.edu/api/catalog/data/catalog/cuscholar-final-final.json?query='
    # req = requests.get(url + query)
    # data = req.json()
    # if data['count'] == 1:
    #     itm = data['results'][0]
    #     print("update")
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


def articleAcademicAffiliation(itm):
    if itm['department'].strip():
        val = itm['department']
    else:
        val = academicAffiliation(itm)
    return val


def academicAffiliation(itm):
    # csvfile = open(academic_affiliation_file,'r')
    # amap = [{k: v for k, v in row.items()} for row in csv.DictReader(csvfile,delimiter='|', skipinitialspace=True)]
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


def pubDateFormat(itm):
    try:
        mydate = parse(itm["publication_date"])
        value = mydate.strftime("%Y-%m-%d")
    except:
        value = ""
    return value


def identifierFormat(itm):
    value = ''
    if itm['pubmedid'].strip():
        value = "PubMed ID: {0}".format(itm['pubmedid'])
    if itm['identifier'].strip():
        if value:
            value = "{0}; {1}".foramt(value, itm['identifier'])
        else:
            value = itm['identifier']
    if itm['external_article_id'].strip():
        if value:
            value = "{0}; External Arcticle ID: {1}".format(
                value, itm['external_article_id'])
        else:
            value = "External Arcticle ID: {0}".format(
                itm['external_article_id'])
    return value


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


def setFileExtent(itm):
    value = ''
    if itm['fpage'].strip() and itm['lpage'].strip():
        value = "{0}-{1}".format(itm['fpage'].strip(), itm['lpage'].strip())
    elif itm['fpage'].strip() or itm['lpage'].strip():
        value = "{0}{1}".format(
            itm['fpage'].strip(), itm['lpage'].strip()).strip()
    return value


def transform(itm):
    data_row = dict.fromkeys(csv_headers, '')
    data_row.update(defaults)
    data_row['title'] = itm['title']
    data_row['creator'] = clean_format_name(
        itm['authors'], divider=csv_divider)
    data_row['abstract'] = clean_abstract_text(itm['abstract'])
    # data_row['date created'] = itm['publication_date'].split(' ')[0]
    # data_row['date_created'] = itm['publication_date'].split(' ')[0]
    data_row['subject'] = csv_divider.join(itm['keywords'])
    data_row['keyword'] = csv_divider.join(itm['keywords'])
    if not data_row['keyword']:
        data_row['keyword'] = 'Keyword'
    data_row['academic_affiliation'] = articleAcademicAffiliation(
        itm)  # academicAffiliation(itm)
    data_row['license'] = itm['distribution_license']
    data_row['publisher'] = itm["publisher"]
    data_row['identifier'] = identifierFormat(itm)
    data_row['related url'] = itm['url']
    # data_row['date_available'] = itm["publication_date"].split(' ')[0]
    # itm["publication_date"].split('-')[0]
    data_row['date_issued'] = pubDateFormat(itm)
    data_row['doi'] = itm['doi']
    data_row['peerreviewed'] = itm['peer_reviewed']
    data_row['replaces'] = replaces(itm)
    # Article
    data_row['has_journal'] = itm['source_publication']
    data_row['has_number'] = itm['issnum']
    data_row['has_volume'] = itm['volnum']
    data_row['issn'] = itm['issn']
    data_row['editor'] = itm['editor']
    data_row['bibliographic_citation'] = itm['custom_citation']
    data_row['additional_information'] = additonal_information(itm)
    data_row['file_extent'] = setFileExtent(itm)
    try:
        #data_row['files'] = 'ableToDownload.pdf'
        data_row['files'] = getFiles(itm)
    except UnableToDownload:
        data_row['files'] = 'unableToDownload.pdf'
    return data_row


def writeCsvFile(csv_data, error_data, count):
    now = datetime.now().isoformat().replace(':', '').split('.')[0]
    keys = csv_data[0].keys()
    filename = 'csv_output/{0}_{1}_dataload_{2}.csv'.format(
        now, defaults['resource type'].replace(' ', '_').lower(), count)
    errorfilename = 'csv_output/{0}_{1}_error_{2}.json'.format(
        now, defaults['resource type'].replace(' ', '_').lower(), count)
    with open(filename, 'w') as output_file:
        dict_writer = csv.DictWriter(output_file, keys)
        dict_writer.writeheader()
        dict_writer.writerows(csv_data)
    if error_data:
        with open(errorfilename, 'w') as output_file:
            output_file.write(json.dumps(error_data, indent=4))
    # Dedup
    df = pd.read_csv(filename, sep=",")
    df.drop_duplicates(subset=None, inplace=True)
    df.to_csv(filename, index=False)


def loadItems(work_type="graduate_thesis_or_dissertations"):
    # login()
    req = requests.get(api_url)
    data = req.json()
    csv_data = []
    error_data = []
    count = 0
    for itm in data['results']:
        try:
            # data = transform(itm)
            csv_data.append(transform(itm))
            print(itm)
            print("List Count: ", len(csv_data))
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
    print("count: ", count)


if __name__ == "__main__":
    loadItems()
