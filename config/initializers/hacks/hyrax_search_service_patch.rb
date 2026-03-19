# frozen_string_literal: true

## CUBL change:
# Override method_missing in Hyrax::SearchService to remove the deprecation warning that is frequently printed in the
# logs due to the Blacklight gem trying to access "current_ability."
module HyraxSearchServicePatch
  def method_missing(method_name, *arguments, &block)
    if scope&.respond_to?(method_name)
      # Deprecation.warn(self.class, "Calling `#{method_name}` on scope " \
      #   'is deprecated and will be removed in Blacklight 8. Call #to_h first if you ' \
      #   ' need to use hash methods (or, preferably, use your own SearchState implementation)')
      scope&.public_send(method_name, *arguments, &block)
    else
      super
    end
  end

  # Always override respond_to_missing? alongside method_missing
  def respond_to_missing?(method_name, include_private = false)
    scope&.respond_to?(method_name, include_private) || super
  end
end

Hyrax::SearchService.prepend(HyraxSearchServicePatch)
