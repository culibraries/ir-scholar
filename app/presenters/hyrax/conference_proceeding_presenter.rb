# Generated via
#  `rails generate hyrax:work ConferenceProceeding`
module Hyrax
  class ConferenceProceedingPresenter < Hyrax::WorkShowPresenter
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
    :resource_type,
    :rights_statement, to: :solr_document
  end
end
# :additional_information,
# :embargo_reason,
# :peerreviewed,