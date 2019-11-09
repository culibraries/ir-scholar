# Generated via
#  `rails generate hyrax:work Default`
module Hyrax
  class DefaultPresenter < Hyrax::WorkShowPresenter
    extend ActiveSupport::Concern
    delegate :title,:abstract,:academic_affiliation,:additional_information,:alt_title,:bibliographic_citation,:conference_location,:conference_name,
    :contributor,:contributor_advisor,:contributor_committeemember,:creator,:date_available,:date_issued,:date_modified,:date_uploaded,
    :degree_field,:degree_grantors,:degree_name,:depositor,:doi,:editor,
    :graduation_year,:has_journal,:has_number,:has_volume,:identifier,:in_series,:is_referenced_by,:isbn,:issn,:keyword,
    :language,:license,:location,:other_affiliation,:peerreviewed,:publisher,:replaces,:resource_type,:rights_statement,
    to: :solr_document
  end
  def name 
    "DefaultPresenter"
  end
end
#:embargo_reason,:file_extent,:file_format,