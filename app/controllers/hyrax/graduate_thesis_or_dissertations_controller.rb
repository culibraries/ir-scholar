# Generated via
#  `rails generate hyrax:work GraduateThesisOrDissertation`
module Hyrax
  # Generated controller for GraduateThesisOrDissertation
  class GraduateThesisOrDissertationsController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include Hyrax::WorksControllerBehavior
    include Hyrax::BreadcrumbsForWorks
    self.curation_concern_type = ::GraduateThesisOrDissertation

    # Use this line if you want to use a custom presenter
    self.show_presenter = Hyrax::GraduateThesisOrDissertationPresenter
  end
end
