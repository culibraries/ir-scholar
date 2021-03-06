# Generated via
#  `rails generate hyrax:work UndergraduateHonorsThesis`
require File.expand_path('../../scholar/scholar_etd_form.rb', __FILE__)
module Hyrax
  # Generated form for UndergraduateHonorsThesis
  class UndergraduateHonorsThesisForm < Scholar::EtdWorkForm
    self.model_class = ::UndergraduateHonorsThesis
    #self.terms += [:resource_type]
    self.required_fields = [:title, :creator,:academic_affiliation, 
      :resource_type, :date_issued, :rights_statement]
    self.terms -=[:degree_name,:degree_level,:degree_name,:graduation_year]
    def self.multiple?(field)
      if [:resource_type].include? field.to_sym
        false
        #,:language :academic_affiliation, 
      else
        super
      end
    end

    def self.model_attributes(_)
      attrs = super
      #attrs[:academic_affiliation] = Array(attrs[:academic_affiliation]) if attrs[:academic_affiliation]
      attrs[:resource_type] = Array(attrs[:resource_type]) if attrs[:resource_type]
      # attrs[:language] = Array(attrs[:language]) if attrs[:language]
      attrs
    end

    # def academic_affiliation
    #   super.first || ""
    # end
    def resource_type
      super.first || ""
    end
    # def language
    #   super.first || ""
    # end
  end
end


# def self.multiple?(field)
#   if [:academic_affiliation, :language ].include? field.to_sym
#     false
#   else
#     super
#   end
# end

# def self.model_attributes(_)
#   attrs = super
#   attrs[:academic_affiliation] = Array(attrs[:academic_affiliation]) if attrs[:academic_affiliation]
#   attrs[:language] = Array(attrs[:language]) if attrs[:language]
  
#   attrs
# end

# def academic_affiliation
#   super.first || ""
# end
# def language
#   super.first || ""
# end

