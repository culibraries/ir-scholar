# Generated via
#  `rails generate hyrax:work ConferenceProceeding`
require File.expand_path('../../scholar/scholar_work_form.rb', __FILE__)
module Hyrax
  # Generated form for ConferenceProceeding
  class ConferenceProceedingForm < Scholar::GeneralWorkForm
    self.model_class = ::ConferenceProceeding
    # self.terms += [:resource_type]
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
