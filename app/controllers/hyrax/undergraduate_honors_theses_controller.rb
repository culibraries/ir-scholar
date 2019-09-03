# Generated via
#  `rails generate hyrax:work UndergraduateHonorsThesis`
module Hyrax
  # Generated controller for UndergraduateHonorsThesis
  class UndergraduateHonorsThesesController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include Hyrax::WorksControllerBehavior
    include Hyrax::BreadcrumbsForWorks
    self.curation_concern_type = ::UndergraduateHonorsThesis

    # Use this line if you want to use a custom presenter
    self.show_presenter = Hyrax::UndergraduateHonorsThesisPresenter
  end
end
