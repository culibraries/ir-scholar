# Generated via
#  `rails generate hyrax:work BookChapter`
require File.expand_path('../../scholar/scholar_work_form.rb', __FILE__)
module Hyrax
  # Generated form for BookChapter
  class BookChapterForm < Scholar::GeneralWorkForm
    self.model_class = ::BookChapter
    # self.terms += [:resource_type]
  end
end
