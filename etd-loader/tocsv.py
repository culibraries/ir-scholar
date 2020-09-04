import os,glob
import json
import xmltodict
import re
from six.moves.html_parser import HTMLParser
from bs4 import BeautifulSoup
import csv
from dateutil.parser import parse
from functools import reduce
from datetime import datetime
import logging

csv_divider = "|~|"

csv_headers = ['title', 'date created', 'resource type', 'creator', 'contributor', 'keyword', 'license', 'rights statement', 'publisher',
               'subject', 'language', 'identifier', 'location', 'related_url', 'bibliographic_citation', 'source', 'abstract', 'academic_affiliation',
               'additional_information', 'alt_title', 'contributor_advisor', 'contributor_committeemember', 'date_available', 'date_issued', 'degree_grantors',
               'degree_level', 'doi', 'embargo_reason', 'graduation_year', 'peerreviewed', 'replaces', 'language', 'admin_set_id', 'visibility', 'files']

defaults = {'language': 'http://id.loc.gov/vocabulary/iso639-2/eng',
            'rights statement': 'http://rightsstatements.org/vocab/InC/1.0/',
            'degree_grantors': 'http://id.loc.gov/authorities/names/n50000485',
            'admin_set_id': 'k643b116n',
            'visibility': 'open',
            'resource type': 'Dissertation',
            'degree_level': 'Doctoral',
            'degree_grantors': 'http://id.loc.gov/authorities/names/n50000485'
            }


def transform(item):
    data_row = dict.fromkeys(csv_headers, '')
    data_row.update(defaults)
    data_row['title'] = itm['DISS_description']['DISS_title']

def getAcademicMap():
    academic_affiliation_file = "academicAffiliationMap.csv"
    csvfile = open(academic_affiliation_file, 'r')
    academicMap = [{k: v for k, v in row.items()} for row in csv.DictReader(
        csvfile, delimiter='|', skipinitialspace=True)]
    csvfile.close()
    return academicMap


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
    search_replace = []
    for idx, itm in enumerate(starts, start=0):
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


def academicAffiliation(itm):
    academicMap = getAcademicMap()
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


def writeCsvFile(csv_data, error_data, count):
    now = datetime.now().isoformat().replace(':', '').split('.')[0]
    keys = csv_data[0].keys()
    with open('{0}_{1}_dataload_{2}.csv'.format(now, defaults['resource type'].lower(), count), 'w') as output_file:
        dict_writer = csv.DictWriter(output_file, keys)
        dict_writer.writeheader()
        dict_writer.writerows(csv_data)
    if error_data:
        with open('file1/{0}_{1}_error_{2}.json'.format(now, defaults['resource type'].lower(), count), 'w') as output_file:
            output_file.write(json.dumps(error_data, indent=4))


def tocsv(source):
    csv_data = []
    error_data = []
    count = 0
    try:
        for root, dirs, files in os.walk(source):
             for dir in dirs:
                os.chdir(os.path.join(root, dir))
                for file in glob.glob("*.xml"):
                    with open(file) as fd:
                        itm = xmltodict.parse(fd.read(), process_namespaces=True)[
                                            'DISS_submission']
                    print(itm)
    except Exception as e:
        print(e)
        # logging.error('Error at %s', 'division', exc_info=e)
        # error_data.append(itm)

    # Write remaining csv if data
    # if csv_data or error_data:
    #     writeCsvFile(csv_data, error_data, count)
    # print(getAcademicMap())
