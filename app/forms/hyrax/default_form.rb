# Generated via
#  `rails generate hyrax:work Default`
require File.expand_path('../../scholar/scholar_work_form.rb', __FILE__)
module Hyrax
  # Generated form for Default
  class DefaultForm  < Scholar::GeneralWorkForm
    self.model_class = ::Default
    
    self.terms -= [:conference_location,:conference_name,:has_journal,:has_number,:has_volume,:issn]
    
    self.required_fields = [:title, :creator,:academic_affiliation, :resource_type, :rights_statement]
  end
end
