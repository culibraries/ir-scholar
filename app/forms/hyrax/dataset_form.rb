# Generated via
#  `rails generate hyrax:work Dataset`
require File.expand_path('../../scholar/scholar_work_form.rb', __FILE__)
module Hyrax
  # Generated form for Dataset
  class DatasetForm < Scholar::GeneralWorkForm
    self.model_class = ::Dataset
    # subtract self.terms 
    self.terms -= [:conference_location,:conference_name,:has_journal,:has_number,:has_volume,:issn]
    
    self.required_fields = [:title, :creator,:academic_affiliation, :resource_type, :rights_statement]

    def self.multiple?(field)
      if [:academic_affiliation, :resource_type ].include? field.to_sym
        true
      else
        super
      end
    end

  end
end