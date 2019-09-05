# Generated via
#  `rails generate hyrax:work TechnicalReport`
#require 'scholar_work_form.rb'
require File.expand_path('../../scholar/scholar_work_form.rb', __FILE__)
module Hyrax
  # Generated form for TechnicalReport
  class TechnicalReportForm < Scholar::GeneralWorkForm
    self.model_class = ::TechnicalReport
    # self.terms += [:resource_type]
  end
end
