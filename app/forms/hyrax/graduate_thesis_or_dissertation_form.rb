# Generated via
#  `rails generate hyrax:work GraduateThesisOrDissertation`
require File.expand_path('../../scholar/scholar_etd_form.rb', __FILE__)
module Hyrax
  # Generated form for GraduateThesisOrDissertation
  class GraduateThesisOrDissertationForm < Scholar::EtdWorkForm
    self.model_class = ::GraduateThesisOrDissertation
    #self.terms += [:resource_type]
    self.terms -=[:contributor]
    #self.terms +=[:degree_name]

    def self.multiple?(field)
      if [:academic_affiliation, :resource_type].include? field.to_sym
        false
        #,:language , :degree_name
      else
        super
      end
    end

    def self.model_attributes(_)
      attrs = super
      attrs[:academic_affiliation] = Array(attrs[:academic_affiliation]) if attrs[:academic_affiliation]
      attrs[:resource_type] = Array(attrs[:resource_type]) if attrs[:resource_type]
      #attrs[:degree_name] = Array(attrs[:degree_name]) if attrs[:degree_name]
      # attrs[:language] = Array(attrs[:language]) if attrs[:language]
      attrs
    end

    def academic_affiliation
      super.first || ""
    end
    def resource_type
      super.first || ""
    end

    # def degree_name
    #   dn =self[Solrizer.solr_name('degree_name')]
    #   dn.first || ""
    # end
    
  end
end
