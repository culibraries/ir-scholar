# frozen_string_literal: true

## CUBL change:
# This overrides the default behavior of the VisibilityCopyJob to use ActiveFedora works instead of being agnostic to
# work types since that functionality is not working for us with this version of Hyrax.
# This makes it so changing the visibility of a work also changes the visibility of all of its associated file sets.
module Hyrax
  class VisibilityCopyJob < Hyrax::ApplicationJob
    # @api public
    # @param [Hyrax::WorkBehavior, Hyrax::Resource] work - a Work model,
    #   using ActiveFedora or Valkyrie
    def perform(work)
      af_work = ActiveFedora::Base.find(work.id.to_s)
      Hyrax::VisibilityPropagator.for(source: af_work).propagate
    end
  end
end
