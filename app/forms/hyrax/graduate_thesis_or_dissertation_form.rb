# Generated via
#  `rails generate hyrax:work GraduateThesisOrDissertation`
require File.expand_path('../../scholar/scholar_etd_form.rb', __FILE__)
module Hyrax
  # Generated form for GraduateThesisOrDissertation
  class GraduateThesisOrDissertationForm < Scholar::EtdWorkForm
    self.model_class = ::GraduateThesisOrDissertation
    #self.terms += [:resource_type]
    self.terms -=[:contributor]

    def self.multiple?(field)
      if [:academic_affiliation, :resource_type].include? field.to_sym
        false
        #,:language
      else
        super
      end
    end

    def self.model_attributes(_)
      attrs = super
      attrs[:academic_affiliation] = Array(attrs[:academic_affiliation]) if attrs[:academic_affiliation]
      attrs[:resource_type] = Array(attrs[:resource_type]) if attrs[:resource_type]
      # attrs[:language] = Array(attrs[:language]) if attrs[:language]
      attrs
    end

    def academic_affiliation
      super.first || ""
    end
    def resource_type
      super.first || ""
    end
    # def language
    #   super.first || ""
    # end
  end
end
