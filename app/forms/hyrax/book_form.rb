# Generated via
#  `rails generate hyrax:work Book`
require File.expand_path('../../scholar/scholar_work_form.rb', __FILE__)
module Hyrax
  # Generated form for Book
  class BookForm < Scholar::GeneralWorkForm
    self.model_class = ::Book
    # self.terms += [:resource_type]
  end
end
