# Generated via
#  `rails generate hyrax:work Article`
require File.expand_path('../../scholar/scholar_article_form.rb', __FILE__)
module Hyrax
  # Generated form for Article
  class ArticleForm < Scholar::ArticleWorkForm
    self.model_class = ::Article
    #self.terms += [:resource_type]
    def self.multiple?(field)
      if [:academic_affiliation, :resource_type ].include? field.to_sym
        true
      else
        super
      end
    end
    
  end
end
