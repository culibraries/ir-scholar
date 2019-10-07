# Generated via
#  `rails generate hyrax:work UndergraduateHonorsThesis`
module Hyrax
  class UndergraduateHonorsThesisPresenter < Hyrax::WorkShowPresenter
    delegate :abstract,:academic_affiliation,:additional_information,:alt_title,:bibliographic_citation,:conference_location,:conference_name,
    :contributor,:contributor_advisor,:contributor_committeemember,:creator,:date_available,:date_issued,:date_modified,:date_uploaded,
    :degree_field,:degree_grantors,:degree_name,:depositor,:doi,:editor,:embargo_reason,:file_extent,:file_format,
    :graduation_year,:has_journal,:has_number,:has_volume,:identifier,:in_series,:is_referenced_by,:isbn,:issn,:keyword,
    :language,:license,:location,:other_affiliation,:peerreviewed,:publisher,:replaces,:resource_type,:rights_statement,
    to: :solr_document
  end
end
