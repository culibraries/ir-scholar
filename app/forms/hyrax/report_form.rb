# Generated via
require File.expand_path('../../scholar/scholar_work_form.rb', __FILE__)
#  `rails generate hyrax:work Report`
module Hyrax
  # Generated form for Report
  class ReportForm < Scholar::GeneralWorkForm
    self.model_class = ::Report
    # Subtract self.terms 
    self.terms -= [:conference_location,:conference_name,:event_date,:has_journal,:has_number,:has_volume,:issn]

    self.required_fields = [:title, :creator,:academic_affiliation, :resource_type, :rights_statement]

  end
end
