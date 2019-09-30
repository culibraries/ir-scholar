# Generated via
#  `rails generate hyrax:work Presentation`
require File.expand_path('../../scholar/scholar_work_form.rb', __FILE__)
module Hyrax
  # Generated form for Presentation
  class PresentationForm < Scholar::GeneralWorkForm
    self.model_class = ::Presentation
    #self.terms += [:resource_type]
    self.terms -= [:has_journal,:has_number,:has_volume,:issn]

    self.required_fields = [:title, :creator,:academic_affiliation, :resource_type, :rights_statement]

    def self.multiple?(field)
      if [:academic_affiliation, :resource_type ].include? field.to_sym
        true
      else
        super
      end
    end


  end
end
