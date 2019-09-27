# Generated via
#  `rails generate hyrax:work TechnicalReport`
#require 'scholar_work_form.rb'
require File.expand_path('../../scholar/scholar_work_form.rb', __FILE__)
module Hyrax
  # Generated form for TechnicalReport
  class TechnicalReportForm < Scholar::GeneralWorkForm
    self.model_class = ::TechnicalReport
    # Subtract self.terms 
    self.terms -= [:conference_location,:conference_name,:date_issued,:has_journal,:has_number,:has_volume,:issn]

    self.required_fields = [:title, :creator,:academic_affiliation, :resource_type, :rights_statement]
  end
end
:title
:creator
:academic_affiliation
:resource_type
:rights_statement