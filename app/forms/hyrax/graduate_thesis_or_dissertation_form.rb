# Generated via
#  `rails generate hyrax:work GraduateThesisOrDissertation`
require File.expand_path('../../scholar/scholar_etd_form.rb', __FILE__)
module Hyrax
  # Generated form for GraduateThesisOrDissertation
  class GraduateThesisOrDissertationForm < Scholar::EtdWorkForm
    self.model_class = ::GraduateThesisOrDissertation
    #self.terms += [:resource_type]
  end
end
