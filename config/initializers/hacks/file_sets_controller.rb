# frozen_string_literal: true

## CUBL Change:
# This casts ActiveFedora FileSets to their Valkyrie resource form when appropriate because ActiveFedora FileSets aren't
# handled as well by the Hyrax code
Hyrax::FileSetsController.class_eval do
  before_action :cast_file_set

  def cast_file_set
    return unless @file_set.class == ::FileSet
    @file_set = @file_set.valkyrie_resource if @file_set.respond_to?(:parent) && @file_set.parent.nil?
  end
end
