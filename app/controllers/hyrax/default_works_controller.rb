# Generated via
#  `rails generate hyrax:work DefaultWork`
module Hyrax
  # Generated controller for DefaultWork
  class DefaultWorksController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include Hyrax::WorksControllerBehavior
    include Hyrax::BreadcrumbsForWorks
    self.curation_concern_type = ::DefaultWork

    # Use this line if you want to use a custom presenter
    self.show_presenter = Hyrax::DefaultWorkPresenter
  end
end
