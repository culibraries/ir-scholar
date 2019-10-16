# Generated via
#  `rails generate hyrax:work ConferenceProceeding`
require File.expand_path('../../scholar/scholar_work_form.rb', __FILE__)
module Hyrax
  # Generated form for ConferenceProceeding
  class ConferenceProceedingForm < Scholar::GeneralWorkForm
    self.model_class = ::ConferenceProceeding
    # self.terms += [:resource_type]
    self.required_fields = [:title, :creator,:academic_affiliation, :resource_type, :rights_statement]

    
  end
end
