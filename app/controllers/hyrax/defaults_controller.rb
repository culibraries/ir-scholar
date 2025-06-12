# Generated via
#  `rails generate hyrax:work Default`
module Hyrax
  # Generated controller for Default
  class DefaultsController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include Hyrax::WorksControllerBehavior
    include Hyrax::BreadcrumbsForWorks
    self.curation_concern_type = ::Default

    # Use this line if you want to use a custom presenter
    self.show_presenter = Hyrax::DefaultPresenter
  end
end
