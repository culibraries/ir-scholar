import os
import glob
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
# from xmltos3 import xmltos3

csv_divider = "|~|"

csv_headers = ['title', 'date created', 'resource type', 'creator', 'contributor', 'keyword', 'license', 'rights statement', 'publisher',
               'subject', 'language', 'identifier', 'location', 'related_url', 'bibliographic_citation', 'source', 'abstract', 'academic_affiliation',
               'additional_information', 'alt_title', 'contributor_advisor', 'contributor_committeemember', 'date_available', 'date_issued', 'degree_grantors',
               'degree_level', 'doi', 'embargo_reason', 'graduation_year', 'peerreviewed', 'replaces', 'language', 'admin_set_id', 'visibility', 'files','replaces']

defaults = {'language': 'http://id.loc.gov/vocabulary/iso639-2/eng',
            'rights statement': 'http://rightsstatements.org/vocab/InC/1.0/',
            'degree_grantors': 'http://id.loc.gov/authorities/names/n50000485',
            'admin_set_id': 'k643b116n',
            'visibility': 'open',
            'resource type': 'Dissertation',
            #NOTE: check on resource type : dissertation, masters thesis, doctoral thesis
            'degree_level': 'Doctoral',
            #NOTE: Doctoral, Masters
            'degree_grantors': 'http://id.loc.gov/authorities/names/n50000485'
            }


def transform(itm, file):
    data_row = dict.fromkeys(csv_headers, '')
    data_row.update(defaults)
    data_row['title'] = itm['DISS_description']['DISS_title']

    author_name = itm['DISS_authorship']['DISS_author']['DISS_name']
    data_row['creator'] = formatName(author_name)

    description = itm['DISS_description']
    if description['DISS_advisor']:
        data_row['contributor_advisor'] = formatName(
            description['DISS_advisor']['DISS_name'])
    else:
        data_row['contributor_advisor'] = ''

    if description['DISS_cmte_member']:
        data_row['contributor_committeemember'] = combineName(
            description['DISS_cmte_member'])
    else:
        data_row['contributor_committeemember'] = ''

    data_row['abstract'] = cleanAbstractText(
        itm['DISS_content']['DISS_abstract']['DISS_para'])

    data_row['subject'] = csv_divider.join(
        description['DISS_categorization']['DISS_keyword'].split(', '))
    data_row['keyword'] = csv_divider.join(
        description['DISS_categorization']['DISS_keyword'].split(', '))

    ########### need to review #########

    data_row['academic_affiliation'] = ''
    data_row['graduation_year'] = ''
    data_row['license'] = ''
    data_row['publisher'] = ''
    data_row['identifier'] = ''
    data_row['related url'] = ''
    data_row['date_available'] = ''
    data_row['date_issued'] = ''
    data_row['doi'] = ''
    data_row['degree_name'] = description['DISS_degree']
    data_row['peerreviewed'] = ''
    data_row['replaces'] = replaces(file)
    data_row['bibliographic_citation'] = ''
    data_row['additional_information'] = ''
    data_row['files'] = itm['DISS_content']['DISS_binary']
    return data_row


def getAcademicMap():
    academic_affiliation_file = "academicAffiliationMap.csv"
    csvfile = open(academic_affiliation_file, 'r')
    academicMap = [{k: v for k, v in row.items()} for row in csv.DictReader(
        csvfile, delimiter='|', skipinitialspace=True)]
    csvfile.close()
    return academicMap


def combineName(names, divider="|~|"):
    newName = []
    for name in names:
        full_name = formatName(name['DISS_name'])
        newName.append(full_name)
    return divider.join(newName)


def formatName(name):
    first_name = name.get('DISS_fname', '')
    sur_name = name.get('DISS_surname', '')
    suffix = name.get('DISS_suffix', '')
    middle_name = name.get('DISS_middle', '')
    return '{} {},{} {}'.format(xstr(suffix), xstr(sur_name), xstr(first_name), xstr(middle_name))


def xstr(s):
    return '' if s is None else str(s)


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


def cleanAbstractText(html):
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


def replaces(file):
    # upload xml to s3
    print("Upload XML file to S3")
    # url = xmltos3()
    return "{0}|{1}".format(os.path.splitext(os.path.basename(file))[0].split('_')[-1], 'test')


def additonal_information(itm):
    if itm['source_publication'].strip() and itm['comments'].strip():
        value = "{0} - {1}".format(cleanAbstractText(
            itm['comments']), itm['source_publication'])
    elif itm['comments'].strip():
        value = "{0}".format(cleanAbstractText(itm['comments']))
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
        with open('{0}_{1}_error_{2}.json'.format(now, defaults['resource type'].lower(), count), 'w') as output_file:
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
                    print("Found: " + file)
                    with open(file) as fd:
                        itm = xmltodict.parse(fd.read(), process_namespaces=True)[
                            'DISS_submission']
                        csv_data.append(transform(itm, '{0}{1}/{2}'.format(root, dir, file)))
                        writeCsvFile(csv_data, error_data, count)
    except Exception as e:
        print(e)
        logging.error('Error at %s', 'division', exc_info=e)
        error_data.append(itm)
