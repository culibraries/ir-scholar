# Generated via
#  `rails generate hyrax:work Article`
require File.expand_path('../../scholar/scholar_article_form.rb', __FILE__)
module Hyrax
  # Generated form for Article
  class ArticleForm < Scholar::ArticleWorkForm
    self.model_class = ::Article
    self.terms += [:resource_type]
  end
end
