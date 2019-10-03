# Generated via
#  `rails generate hyrax:work Article`
require File.expand_path('../../scholar/scholar_article_form.rb', __FILE__)
module Hyrax
  # Generated form for Article
  class ArticleForm < Scholar::ArticleWorkForm
    self.model_class = ::Article
    #self.terms += [:resource_type]
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
