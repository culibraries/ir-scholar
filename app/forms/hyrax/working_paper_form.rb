# Generated via
#  `rails generate hyrax:work WorkingPaper`
require File.expand_path('../../scholar/scholar_work_form.rb', __FILE__)
module Hyrax
  # Generated form for WorkingPaper
  class WorkingPaperForm < Scholar::GeneralWorkForm
    self.model_class = ::WorkingPaper
    # self.terms += [:resource_type]
  end
end
