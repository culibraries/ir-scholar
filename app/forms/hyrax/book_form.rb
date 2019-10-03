# Generated via
#  `rails generate hyrax:work Book`
#require File.expand_path('../../scholar/scholar_work_form.rb', __FILE__)
module Hyrax
  # Generated form for Book
  class BookForm  < Hyrax::Forms::WorkForm
    self.model_class = ::Book
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

    def self.multiple?(field)
      if [:academic_affiliation, :language ].include? field.to_sym
        false
      else
        super
      end
    end

    def self.model_attributes(_)
      attrs = super
      attrs[:academic_affiliation] = Array(attrs[:academic_affiliation]) if attrs[:academic_affiliation]
      attrs[:language] = Array(attrs[:language]) if attrs[:language]
      attrs
    end

    
    # def language
    #   super.first || ""
    # end
    
    # def academic_affiliation
    #   super.first || ""
    # end
    
  end
end
