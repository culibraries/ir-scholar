# Generated via
#  `rails generate hyrax:work Report`
module Hyrax
  class ReportPresenter < Hyrax::WorkShowPresenter
    extend ActiveSupport::Concern
    delegate :title, :abstract, :academic_affiliation, :additional_information, :alternative_title, :bibliographic_citation, :conference_location, :conference_name,
      :contributor, :contributor_advisor, :contributor_committeemember, :creator, :date_available, :date_issued, :date_modified, :date_uploaded,
      :degree_field, :degree_grantors, :degree_name, :depositor, :doi, :editor, :embargo_reason, :file_extent, :file_format,
      :graduation_year, :has_journal, :has_number, :has_volume, :identifier, :in_series, :is_referenced_by, :isbn, :issn, :keyword,
      :language, :license, :location, :other_affiliation, :peerreviewed, :publisher, :replaces, :resource_type, :rights_statement,
      to: :solr_document

    def name
      "ReportPresenter"
    end

    # def representative_presenter
    #   return nil if representative_id.blank?
    #
    #   @representative_presenter ||= begin
    #     result = member_presenters([representative_id]).first
    #     return nil if result.try(:id) == id  # Prevent self-referencing
    #     if result.is_a?(Hyrax::WorkShowPresenter)  # Ensure we don’t return a Work
    #       result.representative_presenter || result.member_presenters.find { |p| p.is_a?(Hyrax::FileSetPresenter) }
    #     else
    #       result
    #     end
    #   end
    # end
  end
end
