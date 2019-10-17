# Generated via
#  `rails generate hyrax:work BookChapter`
# require File.expand_path('../../scholar/scholar_work_form.rb', __FILE__)
module Hyrax
  # Generated form for BookChapter
  class BookChapterForm < Hyrax::Forms::WorkForm
    self.model_class = ::BookChapter
    # self.terms += [:resource_type]
    self.terms = [:title, :creator, :academic_affiliation,:resource_type, :rights_statement,
      :date_issued, 
      :abstract,
      :isbn,
      :publisher,
      :doi,
      :peerreviewed,
      :editor,
      :contributor,
      :alt_title,
      :identifier,
      :in_series,
      :bibliographic_citation,
      :license,
      :based_near,
      :language,
      :other_affiliation,
      :keyword, 
      :subject,
      :is_referenced_by,
      :additional_information,
      :related_url,
      :representative_id, :thumbnail_id, :rendering_ids, :files,
      :visibility_during_embargo, :embargo_release_date, :visibility_after_embargo,
      :visibility_during_lease, :lease_expiration_date, :visibility_after_lease,
      :visibility, :ordered_member_ids, :in_works_ids,
      :member_of_collection_ids, 
      :admin_set_id, :replaces]
    self.required_fields = [:title, :creator,:academic_affiliation, :resource_type, :rights_statement]
  end
end