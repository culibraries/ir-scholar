# Generated via
#  `rails generate hyrax:work UndergraduateHonorsThesis`
require File.expand_path('../../scholar/scholar_etd_form.rb', __FILE__)
module Hyrax
  # Generated form for UndergraduateHonorsThesis
  class UndergraduateHonorsThesisForm < Scholar::EtdWorkForm
    self.model_class = ::UndergraduateHonorsThesis
    #self.terms += [:resource_type]

    def self.multiple?(field)
      if [:academic_affiliation, :resource_type ].include? field.to_sym
        false
      else
        super
      end
    end

    def self.model_attributes(_)
      attrs = super
      attrs[:academic_affiliation] = Array(attrs[:academic_affiliation]) if attrs[:academic_affiliation]
      attrs[:resource_type] = Array(attrs[:resource_type]) if attrs[:resource_type]
      attrs
    end

    def academic_affiliation
      super.first || ""
    end
    def resource_type
      super.first || ""
    end
    
  end
end
