# Generated via
#  `rails generate hyrax:work ConferenceProceeding`
require File.expand_path('../../scholar/scholar_work_form.rb', __FILE__)
module Hyrax
  # Generated form for ConferenceProceeding
  class ConferenceProceedingForm < Scholar::GeneralWorkForm
    self.model_class = ::ConferenceProceeding
    # self.terms += [:resource_type]
    self.required_fields = [:title, :creator,:academic_affiliation, :resource_type, :rights_statement]

    def self.multiple?(field)
      if [:academic_affiliation ].include? field.to_sym
        false
      else
        super
      end
    end

    def self.model_attributes(_)
      attrs = super
      attrs[:academic_affiliation] = Array(attrs[:academic_affiliation]) if attrs[:academic_affiliation]
      attrs
    end

    def academic_affiliation
      super.first || ""
    end
  end
end
