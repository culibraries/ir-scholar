# Generated via
#  `rails generate hyrax:work WorkingPaper`
module Hyrax
  class WorkingPaperPresenter < Hyrax::WorkShowPresenter
    delegate :resource_type, 
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
    :rights_statement, to: :solr_document
  end
end
# :additional_information,
# :embargo_reason,
# :peerreviewed,