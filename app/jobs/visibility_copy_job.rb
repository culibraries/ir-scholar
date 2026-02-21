# frozen_string_literal: true

module Hyrax
  class VisibilityCopyJob < Hyrax::ApplicationJob
    # @api public
    # @param [Hyrax::WorkBehavior, Hyrax::Resource] work - a Work model,
    #   using ActiveFedora or Valkyrie
    def perform(work)
      Hyrax.logger.warn "VisibilityCopyJob Work: #{work.id}"
      af_work = ActiveFedora::Base.find(work.id)
      Hyrax.logger.warn "VisibilityCopyJob AF Work: #{af_work.id}"
      Hyrax::VisibilityPropagator.for(source: af_work).propagate
    end
  end
end
