# Generated via
#  `rails generate hyrax:work Presentation`
require File.expand_path('../../scholar/scholar_work_form.rb', __FILE__)
module Hyrax
  # Generated form for Presentation
  class PresentationForm < Scholar::GeneralWorkForm
    self.model_class = ::Presentation
    #self.terms += [:resource_type]
  end
end
