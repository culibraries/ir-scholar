# Generated via
#  `rails generate hyrax:work WorkingPaper`
module Hyrax
  # Generated controller for WorkingPaper
  class WorkingPapersController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include Hyrax::WorksControllerBehavior
    include Hyrax::BreadcrumbsForWorks
    self.curation_concern_type = ::WorkingPaper

    # Use this line if you want to use a custom presenter
    self.show_presenter = Hyrax::WorkingPaperPresenter
  end
end
