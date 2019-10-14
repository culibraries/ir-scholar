from bs4 import BeautifulSoup
import requests,json


#example={utf8: "✓", authenticity_token: "g2y4Z+Vs29T4/9As19yXpBM7Ft6Lcfc6rp7uhbakwUNJ3hvETDkAcbmyGLea9led8pOVy5OhQ4HGKi+7cWTbKw==", user[email]: "", user[password]: "", user[remember_me]: "0"}

graduate_thesis_or_dissertation= {"utf8":"✓","authenticity_token":"", "graduate_thesis_or_dissertation":{"title":[], "creator":[], "academic_affiliation":"", "resource_type":"", "degree_level":"", "graduation_year":"", "rights_statement":"http://rightsstatements.org/vocab/NKC/1.0/", "contributor_advisor":[""], "contributor_committeemember":[""], "date_issued":"", "abstract":[""], "degree_grantors":"http://id.loc.gov/authorities/names/n50000485", "publisher":[""], "alt_title":[""], "subject":[""], "doi":"", "bibliographic_citation":[""], "additional_information":[""], "license":[""], "language":"http://id.loc.gov/vocabulary/iso639-2/eng", "identifier":[""], "based_near_attributes":{"0":{"hidden_label":"", "id":"", "_destroy":""}}, "related_url":[""], "replaces":"", "admin_set_id":"3197xm04j", "member_of_collection_ids":"", "visibility":"open", "visibility_during_embargo":"restricted", "embargo_release_date":"2019-10-14", "visibility_after_embargo":"open", "visibility_during_lease":"open", "lease_expiration_date":"2019-10-14", "visibility_after_lease":"restricted"}, "uploaded_files":["7"], "new_group_name_skel":"Select a group", "new_group_permission_skel":"none", "new_user_name_skel":"", "new_user_permission_skel":"none", "agreement":"1"}


{"utf8":"✓","authenticity_token":"GSYJsHgOYf3Nb+3SBOQGBzjVduRn03c9QSqJ0hijV/b/k+gNnMFYreNvjNcVjM8ZJG6yBzcXey4iX5BYDm/gxQ==","graduate_thesis_or_dissertation[title][]":"","graduate_thesis_or_dissertation[creator][]":"","graduate_thesis_or_dissertation[academic_affiliation]":"","graduate_thesis_or_dissertation[resource_type]":"","graduate_thesis_or_dissertation[degree_level]":"","graduate_thesis_or_dissertation[graduation_year]":"","graduate_thesis_or_dissertation[rights_statement]":"","graduate_thesis_or_dissertation[contributor_advisor][]":"","graduate_thesis_or_dissertation[contributor_committeemember][]":"","graduate_thesis_or_dissertation[date_issued]":"","graduate_thesis_or_dissertation[abstract][]":"","graduate_thesis_or_dissertation[degree_grantors]":"","graduate_thesis_or_dissertation[publisher][]":"","graduate_thesis_or_dissertation[alt_title][]":"","graduate_thesis_or_dissertation[subject][]":"","graduate_thesis_or_dissertation[doi]":"","graduate_thesis_or_dissertation[bibliographic_citation][]":"","graduate_thesis_or_dissertation[additional_information][]":"","graduate_thesis_or_dissertation[license][]":"","graduate_thesis_or_dissertation[language]":"http://id.loc.gov/vocabulary/iso639-2/eng","graduate_thesis_or_dissertation[identifier][]":"","graduate_thesis_or_dissertation[based_near_attributes][0][hidden_label]":"","graduate_thesis_or_dissertation[based_near_attributes][0][id]":"","graduate_thesis_or_dissertation[based_near_attributes][0][_destroy]":"","graduate_thesis_or_dissertation[related_url][]":"","graduate_thesis_or_dissertation[replaces]":"","uploaded_files[]":["file:///Users/mast4541/github/cu/ir/develop/scholar/tmp/uploads/hyrax/uploaded_file/file/10/payForPlayShirkingInTheNfl.pdf","file:///Users/mast4541/github/cu/ir/develop/scholar/tmp/restart.txt"],"graduate_thesis_or_dissertation[admin_set_id]":"3197xm04j","graduate_thesis_or_dissertation[member_of_collection_ids]":"","new_group_name_skel":"Select a group","new_group_permission_skel":"none","new_user_name_skel":"","new_user_permission_skel":"none","graduate_thesis_or_dissertation[visibility_during_embargo]":"restricted","graduate_thesis_or_dissertation[embargo_release_date]":"2019-10-15","graduate_thesis_or_dissertation[visibility_after_embargo]":"open","graduate_thesis_or_dissertation[visibility_during_lease]":"open","graduate_thesis_or_dissertation[lease_expiration_date]":"2019-10-15","graduate_thesis_or_dissertation[visibility_after_lease]":"restricted","graduate_thesis_or_dissertation[visibility]":"restricted","selected_files[0][url]":["file:///Users/mast4541/github/cu/ir/develop/scholar/tmp/uploads/hyrax/uploaded_file/file/10/payForPlayShirkingInTheNfl.pdf","file:///Users/mast4541/github/cu/ir/develop/scholar/tmp/restart.txt"],"selected_files[0][file_name]":["payForPlayShirkingInTheNfl.pdf","restart.txt"],"selected_files[0][file_size]":["484898","0"]}

#  "authenticity_token":"bullshit-turnoff-forgery-protection",
#Started POST "/concern/graduate_thesis_or_dissertations" for 127.0.0.1 at 2019-10-13 08:53:32 -0600
#Processing by Hyrax::GraduateThesisOrDissertationsController#create as HTML
api_url="https://libapps.colorado.edu/api/catalog/data/catalog/cuscholar-final.json?query={%22filter%22:{%22document_type%22:%22dissertation%22}}"
base_url="http://localhost:3000"      #/concern/graduate_thesis_or_dissertations/new"
headers={'Content-Type': 'application/json'}

s = requests.session()

def login():
    rep = s.get("{0}/users/sign_in".format(base_url))
    soup = BeautifulSoup(rep.text,'lxml')
    auth_token=soup.find(attrs={"name" : "authenticity_token"})['value']
    #login_data={"utf8":"✓", "authenticity_token":auth_token,"user[email]":"admin@colorado.edu","user[password]": "password1915", "user[remember_me]": "0"}
    login_data='utf8=✓&authenticity_token={0}&user[email]=admin@colorado.edu&user[password]=password1915&user[remember_me]=0'.format(auth_token)
    resp=s.post('{0}/users/sign_in'.format(base_url), data=login_data.encode('utf-8')) #json.dumps(login_data),headers=headers)
    req=s.get("{0}/contact".format(base_url))
    if 'admin@colorado.edu' in req.text:
        print('admin login') 

    
def transformData(itm):
    default_rights_statement="http://rightsstatements.org/vocab/NKC/1.0/"
    data=None
    if itm["document_type"]=="dissertation":
        data=graduate_thesis_or_dissertation
        #data["authenticity_token"]=auth_token
        data['graduate_thesis_or_dissertation']['title']=[itm['title']]
        data['graduate_thesis_or_dissertation']['creator']=[itm['authors']]
        data['graduate_thesis_or_dissertation']['resource_type']="Dissertation"
        data['graduate_thesis_or_dissertation']['academic_affiliation']="Horse Puckey"
        data['graduate_thesis_or_dissertation']['degree_level']="Dissertation"
        data['graduate_thesis_or_dissertation']['degree_year']=itm['publication_date'].split('-')[0]
        data['graduate_thesis_or_dissertation']['degree_year']=default_rights_statement
        data['graduate_thesis_or_dissertation']['uploaded_files[]']="/Users/mast4541/github/cu/ir/develop/scholar/tmp/uploads/hyrax/uploaded_file/file/10/payForPlayShirkingInTheNfl.pdf"
        data['graduate_thesis_or_dissertation']["selected_files[0][url]"]="/Users/mast4541/github/cu/ir/develop/scholar/tmp/uploads/hyrax/uploaded_file/file/10/payForPlayShirkingInTheNfl.pdf"
        data['graduate_thesis_or_dissertation']["selected_files[0][file_name]"]="payForPlayShirkingInTheNfl.pdf"
        data['graduate_thesis_or_dissertation']["selected_files[0][file_size]"]:"484898"
        data['graduate_thesis_or_dissertation']["selected_files[]"]="/Users/mast4541/github/cu/ir/develop/scholar/tmp/uploads/hyrax/uploaded_file/file/10/payForPlayShirkingInTheNfl.pdf"
    return data
    
def loadItems(work_type="graduate_thesis_or_dissertations"):
    login()
    req=requests.get(api_url)
    data=req.json()
    for itm in data['results'][:2]:
        rdata=transformData(itm)
        if rdata:
            #rdata='{"utf8":"✓","authenticity_token":"{0}","graduate_thesis_or_dissertation[title][]":"Thesis Or Dissertation","graduate_thesis_or_dissertation[creator][]":"Thesis Or Dissertation","graduate_thesis_or_dissertation[academic_affiliation]":"Atmospheric and Oceanic Sciences (ATOC)","graduate_thesis_or_dissertation[resource_type]":"Dissertation","graduate_thesis_or_dissertation[degree_level]":"Doctoral","graduate_thesis_or_dissertation[graduation_year]":"2015","graduate_thesis_or_dissertation[rights_statement]":"http://rightsstatements.org/vocab/NKC/1.0/","graduate_thesis_or_dissertation[contributor_advisor][]":"","graduate_thesis_or_dissertation[contributor_committeemember][]":"","graduate_thesis_or_dissertation[date_issued]":"","graduate_thesis_or_dissertation[abstract][]":"","graduate_thesis_or_dissertation[degree_grantors]":"","graduate_thesis_or_dissertation[publisher][]":"","graduate_thesis_or_dissertation[alt_title][]":"","graduate_thesis_or_dissertation[subject][]":"","graduate_thesis_or_dissertation[doi]":"","graduate_thesis_or_dissertation[bibliographic_citation][]":"","graduate_thesis_or_dissertation[additional_information][]":"","graduate_thesis_or_dissertation[license][]":"","graduate_thesis_or_dissertation[language]":"http://id.loc.gov/vocabulary/iso639-2/eng","graduate_thesis_or_dissertation[identifier][]":"","graduate_thesis_or_dissertation[based_near_attributes][0][hidden_label]":"","graduate_thesis_or_dissertation[based_near_attributes][0][id]":"","graduate_thesis_or_dissertation[based_near_attributes][0][_destroy]":"","graduate_thesis_or_dissertation[related_url][]":"","graduate_thesis_or_dissertation[replaces]":"","uploaded_files[]":["8","9"],"graduate_thesis_or_dissertation[admin_set_id]":"3197xm04j","graduate_thesis_or_dissertation[member_of_collection_ids]":"","new_group_name_skel":"Select a group","new_group_permission_skel":"none","new_user_name_skel":"","new_user_permission_skel":"none","graduate_thesis_or_dissertation[visibility]":"open","graduate_thesis_or_dissertation[visibility_during_embargo]":"restricted","graduate_thesis_or_dissertation[embargo_release_date]":"2019-10-15","graduate_thesis_or_dissertation[visibility_after_embargo]":"open","graduate_thesis_or_dissertation[visibility_during_lease]":"open","graduate_thesis_or_dissertation[lease_expiration_date]":"2019-10-15","graduate_thesis_or_dissertation[visibility_after_lease]":"restricted","agreement":"1"}'
            durl="{0}/concern/{1}/".format(base_url,work_type)
            rep = requests.get("{0}new".format(durl))
            soup = BeautifulSoup(rep.text,'lxml')
            auth_token=soup.find(attrs={"name" : "authenticity_token"})['value']
            data["authenticity_token"]=auth_token
            #print (rdata)
            #rdata=u'{"utf8":"✓","authenticity_token":"' + auth_token + '","graduate_thesis_or_dissertation[title][]":"Thesis Or Dissertation","graduate_thesis_or_dissertation[creator][]":"Thesis Or Dissertation","graduate_thesis_or_dissertation[academic_affiliation]":"Atmospheric and Oceanic Sciences (ATOC)","graduate_thesis_or_dissertation[resource_type]":"Dissertation","graduate_thesis_or_dissertation[degree_level]":"Doctoral","graduate_thesis_or_dissertation[graduation_year]":"2015","graduate_thesis_or_dissertation[rights_statement]":"http://rightsstatements.org/vocab/NKC/1.0/","graduate_thesis_or_dissertation[contributor_advisor][]":"","graduate_thesis_or_dissertation[contributor_committeemember][]":"","graduate_thesis_or_dissertation[date_issued]":"","graduate_thesis_or_dissertation[abstract][]":"","graduate_thesis_or_dissertation[degree_grantors]":"","graduate_thesis_or_dissertation[publisher][]":"","graduate_thesis_or_dissertation[alt_title][]":"","graduate_thesis_or_dissertation[subject][]":"","graduate_thesis_or_dissertation[doi]":"","graduate_thesis_or_dissertation[bibliographic_citation][]":"","graduate_thesis_or_dissertation[additional_information][]":"","graduate_thesis_or_dissertation[license][]":"","graduate_thesis_or_dissertation[language]":"http://id.loc.gov/vocabulary/iso639-2/eng","graduate_thesis_or_dissertation[identifier][]":"","graduate_thesis_or_dissertation[based_near_attributes][0][hidden_label]":"","graduate_thesis_or_dissertation[based_near_attributes][0][id]":"","graduate_thesis_or_dissertation[based_near_attributes][0][_destroy]":"","graduate_thesis_or_dissertation[related_url][]":"","graduate_thesis_or_dissertation[replaces]":"","uploaded_files[]":["8","9"],"graduate_thesis_or_dissertation[admin_set_id]":"3197xm04j","graduate_thesis_or_dissertation[member_of_collection_ids]":"","new_group_name_skel":"Select a group","new_group_permission_skel":"none","new_user_name_skel":"","new_user_permission_skel":"none","graduate_thesis_or_dissertation[visibility]":"open","graduate_thesis_or_dissertation[visibility_during_embargo]":"restricted","graduate_thesis_or_dissertation[embargo_release_date]":"2019-10-15","graduate_thesis_or_dissertation[visibility_after_embargo]":"open","graduate_thesis_or_dissertation[visibility_during_lease]":"open","graduate_thesis_or_dissertation[lease_expiration_date]":"2019-10-15","graduate_thesis_or_dissertation[visibility_after_lease]":"restricted","agreement":"1"}'
            
            durl="{0}/concern/{1}/".format(base_url,work_type)
            #print(response.cookies)
            #print(s.cookies.get_dict())
            resp=s.post(durl, data=json.dumps(rdata),headers=headers)
            soup = BeautifulSoup(resp.text,'lxml')
            new_url=soup.find("meta",  property="og:url")
            print("New URL: ",new_url["content"])
            #print(s.cookies.get_dict())
            #print(response.status_code)
            #print(response.cookies)
            with open('errror.txt','w') as f1:
                f1.write(resp.text)

    #requests.get (url


# template= {"utf8":"✓", "authenticity_token":"NQIkUdPfwIsuKbYd3ulgbQ6mt2VZAvtRAqVjknuCEEb5CYYuLhUtsT7knym3hi8Fz4DZ8KiVhhbnE5nBUccwQA==", "graduate_thesis_or_dissertation":{"title":["New Graduate Thesis Or Dissertation"], "creator":["New Graduate Thesis Or Dissertation"], "academic_affiliation":"Astrophysical and Planetary Sciences (APS)", "resource_type":"Dissertation", "degree_level":"Doctoral", "graduation_year":"2018", "rights_statement":"http://rightsstatements.org/vocab/NKC/1.0/", "contributor_advisor":[""], "contributor_committeemember":[""], "date_issued":"", "abstract":[""], "degree_grantors":"http://id.loc.gov/authorities/names/n50000485", "publisher":[""], "alt_title":[""], "subject":[""], "doi":"", "bibliographic_citation":[""], "additional_information":[""], "license":[""], "language":"http://id.loc.gov/vocabulary/iso639-2/eng", "identifier":[""], "based_near_attributes":{"0":{"hidden_label":"", "id":"", "_destroy":""}}, "related_url":[""], "replaces":"", "admin_set_id":"3197xm04j", "member_of_collection_ids":"", "visibility":"open", "visibility_during_embargo":"restricted", "embargo_release_date":"2019-10-14", "visibility_after_embargo":"open", "visibility_during_lease":"open", "lease_expiration_date":"2019-10-14", "visibility_after_lease":"restricted"}, "uploaded_files":["7"], "new_group_name_skel":"Select a group", "new_group_permission_skel":"none", "new_user_name_skel":"", "new_user_permission_skel":"none", "agreement":"1"}


if __name__ == '__main__':
    #login()
    loadItems()
    #soup = BeautifulSoup(rep.text,'lxml')        

