# frozen_string_literal: true

require 'active_support/core_ext/hash'
Hyrax::WorkUploadsHandler.class_eval do
  ##
  # @api private
  #
  # @note the second hash overrides values in the first hash
  #
  # @return [Hash{Symbol => Object}]
  def file_set_args(file, file_set_params = {})
    { depositor: file.user.user_key,
      creator: file.user.user_key,
      date_uploaded: file.created_at,
      date_modified: Hyrax::TimeService.time_in_utc,
      label: file.uploader.filename,
      ## CUBL Change:
      # The "compact_blank" method is not available in Rails 5.1, so until we upgrade, we'll use the previous method to
      # do the same thing, delete_if { |_k, v| v.blank? }
      # This change fixes the "undefined method `title' for Nil:NilClass" errors
      # title: file.uploader.filename }.merge(file_set_params.compact_blank)
      title: file.uploader.filename }.merge(file_set_params.delete_if { |_k, v| v.blank? })
  end
end
