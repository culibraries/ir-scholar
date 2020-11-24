# coding: utf-8
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

logger = logging.getLogger('etd-loader')
hdlr = logging.FileHandler('/Users/dtrinh/efs/test/proquest/logs/etd-loader.log')
formatter = logging.Formatter('%(asctime)s %(levelname)s %(message)s')
hdlr.setFormatter(formatter)
logger.addHandler(hdlr)
logger.setLevel(logging.DEBUG)

csv_divider = "|~|"

csv_headers = ['title', 'date created', 'resource type', 'creator', 'contributor', 'keyword', 'license', 'rights statement', 'publisher',
               'subject', 'language', 'location', 'bibliographic_citation', 'source', 'abstract', 'academic_affiliation',
               'additional_information', 'alt_title', 'contributor_advisor', 'contributor_committeemember', 'date_available', 'date_issued', 'degree_grantors',
               'degree_level', 'doi', 'embargo_reason', 'graduation_year', 'peerreviewed', 'replaces', 'language', 'admin_set_id', 'visibility', 'files','replaces']

defaults = {
            'language': 'http://id.loc.gov/vocabulary/iso639-2/eng',
            'rights statement': 'http://rightsstatements.org/vocab/InC/1.0/',
            'degree_grantors': 'http://id.loc.gov/authorities/names/n50000485',
            'admin_set_id': 'k643b116n',
            'visibility': 'open',
            'resource type': 'Dissertation',
            'degree_level': 'Doctoral',
            'doi': '',
            'peerreviewed': '',
            'embargo_reason': '',
            'bibliographic_citation': '',
            'additional_information': '',
            'alt_title': '',
            'source': '',
            'publisher':'University of Colorado Boulder',
            'license': '',
            'contributor':'',
            'location':''
            }

def transform(itm, file_number, source, file_name, folder_file_name):
    data_row = dict.fromkeys(csv_headers, '')
    data_row.update(defaults)

    description = itm['DISS_description']
    authorship = itm['DISS_authorship']
    content = itm['DISS_content']
    restriction = itm['DISS_restriction']
    repository = itm['DISS_repository']

    data_row['title'] = description.get('DISS_title','No Title')
    data_row['date created'] = description['DISS_dates'].get('DISS_comp_date','')
    if (description['@type'] == 'masters'):
        data_row['resource type'] = 'Masters Thesis'
    if (description['@type'] == 'doctoral'):
        data_row['resource type'] = 'Dissertation'

    data_row['creator'] = combineName(itm['DISS_authorship']['DISS_author'])


    if (description['DISS_categorization'].get('DISS_keyword') is not None):
        data_row['keyword'] = csv_divider.join(
            description['DISS_categorization']['DISS_keyword'].split(', '))
    else:
        data_row['keyword'] = ''

    data_row['subject'] = data_row['keyword'] + csv_divider + getSubjectList(description['DISS_categorization']['DISS_category'])


    data_row['abstract'] = getAbstractPara(content['DISS_abstract'].get('DISS_para','No Abstract'))


    data_row['academic_affiliation'] = description['DISS_institution'].get('DISS_inst_contact','')

    data_row['contributor_advisor'] = combineName(description['DISS_advisor'])
    data_row['contributor_committeemember'] = combineName(description['DISS_cmte_member'])

    data_row['files'] = folder_file_name + '/' + content['DISS_binary']['#text']

    data_row['date_available'] = getDateAvailable(repository.get('DISS_agreement_decision_date', None),
                                                                  description.get('DISS_dates', None),
                                                                  itm['@embargo_code'],
                                                                  restriction)

    data_row['date_issued'] = getDate(repository.get('DISS_agreement_decision_date', None),description.get('DISS_dates', None))

    data_row['embargo_release_date'] = getReleaseDate(itm['@embargo_code'], restriction)

    data_row['visibility'] = getVisibility(itm['@embargo_code'])

    data_row['degree_level'] = getDegreeLevel(description)

    data_row['graduation_year'] = data_row['date_issued'].split('-')[0]

    if 'DISS_attachment' in itm['DISS_content']:
        newFileName = []
        for attachment in itm['DISS_content']['DISS_attachment']:
            newFileName.append(source + '/' + attachment['DISS_file_name'])
        data_row['files'] += '|~|' + '|~|'.join(newFileName)

    data_row['degree_name'] = description['DISS_degree']
    data_row['replaces'] = replaces(file_number,source,file_name)
    return data_row

def getDegreeLevel(description):
    if (description['@type'] == 'masters'):
        return "Master's"
    else:
        return 'Doctoral'

def getVisibility(embargo_code):
    if embargo_code is '0':
        return 'open'
    else:
        return 'restricted'

def getReleaseDate(embargo_code, restriction):
    if embargo_code is not '0':
        if restriction is not None:
            release_date = restriction.get('DISS_sales_restriction', None)
            splitRDate = release_date.get('@remove').split('/')
            return splitRDate[2]+'-'+splitRDate[1]+'-'+splitRDate[0]
        else:
            return ''
    else:
        return ''

def getDateAvailable(decision_date, comp_date, isEmbargo, restriction ):
    if isEmbargo is not '0':
        if restriction is not None:
            releaseDate = restriction.get('DISS_sales_restriction', None)
            splitRDate = releaseDate.get('@remove').split('/')
            return splitRDate[2]+'-'+splitRDate[1]+'-'+splitRDate[0]
    else:
        if (decision_date is not None):
            return decision_date.split(' ')[0]
        else:
            if comp_date.get('DISS_accept_date') is not None:
                splitDate = comp_date.get('DISS_accept_date').split('/')
                if splitDate[0] == '01' and splitDate[1] == '01':
                    return splitDate[2]
                else:
                    return splitDate[2] + '-' + splitDate[1] + '-' + splitDate[0]

def getDate(decision_date, comp_date):
    if (decision_date is not None):
        return decision_date.split(' ')[0]
    else:
        if comp_date.get('DISS_accept_date') is not None:
            splitDate = comp_date.get('DISS_accept_date').split('/')
            if splitDate[0] == '01' and splitDate[1] == '01':
                return splitDate[2]
            else:
                return splitDate[2] + '-' + splitDate[1] + '-' + splitDate[0]

def getAbstractPara(abstract):
    if type(abstract) is not list:
        return abstract
    else:
        newString = ''
        for para in abstract:
            newString += para
        return newString

def getAcademicMap():
    academic_affiliation_file = "academicAffiliationMap.csv"
    csvfile = open(academic_affiliation_file, 'r')
    academicMap = [{k: v for k, v in row.items()} for row in csv.DictReader(
        csvfile, delimiter='|', skipinitialspace=True)]
    csvfile.close()
    return academicMap

def getSubjectList(category):
     if (type(category) is not list):
        return category['DISS_cat_desc']
     else:
        newSubject = []
        for cate in category:
            cateName = cate['DISS_cat_desc']
            newSubject.append(cateName)
        return csv_divider.join(newSubject)

def combineName(names, divider="|~|"):
    if (type(names) is not list):
      return formatName(names['DISS_name'])
    else:
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
    if suffix is None or suffix is '':
        return '{}, {} {}'.format(xstr(sur_name), xstr(first_name), xstr(middle_name))
    if (suffix is None or suffix is '') and (middle_name is None or middle_name is ''):
        return '{}, {}'.format(xstr(sur_name), xstr(first_name))
    return '{}, {} {}, {}'.format(xstr(sur_name), xstr(first_name), xstr(middle_name), xstr(suffix))

def xstr(s):
    return '' if s is None else str(s)

def academicAffiliation(itm):
    academicMap = getAcademicMap()
    match = itm['front_end_url'].split('/')[-2]
    for aa in academicMap:
        if aa['bepress'] == match:
            return aa['samvera']
    return 'Other'

def replaces(file_number, source, file):
    url = xmltos3(source, file)
    url = 'testurl'
    return "{0}|{1}".format(file_number, url)

def writeCsvFile(source, csv_data, error_data):
    now = datetime.now().isoformat().replace(':', '').split('.')[0]
    keys = csv_data[0].keys()
    with open(source + '{0}_dataload.csv'.format(defaults['resource type'].lower()), 'w') as output_file:
        dict_writer = csv.DictWriter(output_file, keys)
        dict_writer.writeheader()
        dict_writer.writerows(csv_data)
        print('- Converted to : ' + source + '{0}_dataload.csv'.format(defaults['resource type'].lower()))

def tocsv(source, file_number, folder_file_name, zip_file_path, rejected_path):
    csv_data = []
    error_data = []
    os.chdir('/data')
    try:
        for file in os.listdir(source):
            if file.endswith(".xml"):
                print("- Found: " + file)
                with open(source + '/' + file) as fd:
                    itm = xmltodict.parse(fd.read(), process_namespaces=True)['DISS_submission']
                    if itm['DISS_repository'].get('DISS_acceptance') is None or itm['DISS_repository'].get('DISS_acceptance') is '0':
                        print('- Log: ' + zip_file_path + ':is not accepted')
                        logger.error(zip_file_path + ' : ' + 'is not accepted')
                        os.system('mv ' + zip_file_path + ' ' + rejected_path)
                        print('- Moved to Rejected folder')
                    elif itm.get('@embargo_code') is '0':
                        csv_data.append(transform(itm, file_number, source + '/', file, folder_file_name))
                        writeCsvFile(source + '/', csv_data, error_data)
                        print('- Execute Rake Task: ' + 'rake etd_import:upload[' + source + '/dissertation_dataload.csv] --trace')
                        os.system('rake etd_import:upload[' + source + '/dissertation_dataload.csv] --trace')
                        os.system('mv ' + zip_file_path + ' ' + zip_file_path+'.processed')
                        print('- Converted .zip to .zip.processed')
                        print('- Done')
                        logger.debug('Success: ' + folder_file_name)
    except Exception as e:
        print('- Error Found:' + str(e))
        logger.error('- Log: ' + zip_file_path + ' : ' + str(e))
        os.system('mv ' + zip_file_path + ' ' + rejected_path)
        print('- Moved to Rejected folder')
