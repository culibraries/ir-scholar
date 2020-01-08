# Generated via
#  `rails generate hyrax:work Presentation`
require File.expand_path('../../scholar/scholar_work_form.rb', __FILE__)
module Hyrax
  # Generated form for Presentation
  class PresentationForm < Scholar::GeneralWorkForm
    self.model_class = ::Presentation
    #self.terms += [:resource_type]
    self.terms -= [:has_journal,:has_number,:has_volume,:issn]
    #self.terms.insert(7,:event_date)

    self.required_fields = [:title, :creator,:academic_affiliation, :resource_type, :rights_statement]

  end
end
