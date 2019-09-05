# Generated via
#  `rails generate hyrax:work GraduateThesisOrDissertation`
module Hyrax
  class GraduateThesisOrDissertationPresenter < Hyrax::WorkShowPresenter
    delegate :resource_type,
    :contributor_advisor,
    :contributor_committeemember,
    :degree_discipline,
    :degree_grantors,
    :graduation_year,
    :abstract,
    :academic_affiliation,
    :alt_title,
    :bibliographic_citation,
    :conference_location,
    :conference_name,
    :contributor,
    :creator,
    :date_available,
    :date_created,
    :date_issued,
    :doi,
    :file_extent,
    :file_format,
    :identifier,
    :in_series,
    :isbn,
    :issn,
    :keyword,
    :language,
    :other_affiliation,
    :publisher,
    :replaces,
    :resource_type,
    :rights_statement, to: :solr_document
  end
end

# :additional_information,
# :embargo_reason,
# :peerreviewed,