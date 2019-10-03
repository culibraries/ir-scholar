# Generated via
require File.expand_path('../../scholar/scholar_work_form.rb', __FILE__)
#  `rails generate hyrax:work Report`
module Hyrax
  # Generated form for Report
  class ReportForm < Scholar::GeneralWorkForm
    self.model_class = ::Report
    # Subtract self.terms 
    self.terms -= [:conference_location,:conference_name,:date_issued,:has_journal,:has_number,:has_volume,:issn]

    self.required_fields = [:title, :creator,:academic_affiliation, :resource_type, :rights_statement]

    def self.multiple?(field)
      if [:academic_affiliation, :language ].include? field.to_sym
        false
      else
        super
      end
    end

    def self.model_attributes(_)
      attrs = super
      attrs[:academic_affiliation] = Array(attrs[:academic_affiliation]) if attrs[:academic_affiliation]
      attrs[:language] = Array(attrs[:language]) if attrs[:language]
      attrs
    end

    def academic_affiliation
      super.first || ""
    end
    def language
      super.first || ""
    end
    

  end
end
