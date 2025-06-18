# app/presenters/hyrax/file_set_presenter_decorator.rb
#
# This decorator adds the 'member_of_collection_ids' method to Hyrax::FileSetPresenter.
# The error message "undefined method `member_of_collection_ids' for #<Hyrax::FileSetPresenter"
# indicates that a view template (likely hyrax/file_sets/show.html.erb) is trying to call this method.
# In Hyrax 3.x, FileSets are typically members of Works, and Works are members of Collections.
# A FileSet does not directly belong to a Collection in the core Hyrax data model.
#
# This implementation retrieves the parent work's presenter and then delegates the call
# to the parent's `member_of_collection_ids` method.

module Hyrax
  module FileSetPresenterDecorator
    # Ensure that this module is prepended to the Hyrax::FileSetPresenter
    # You'll typically do this at the bottom of the file or in an initializer.

    # Define the missing method
    def member_of_collection_ids
      # Try to get the parent work's presenter.
      # The `parent_presenter` method is usually available on FileSetPresenters
      # and should return a WorkPresenter or a similar object.
      parent = try(:parent_presenter)

      # If we have a parent presenter AND it responds to `member_of_collection_ids`,
      # then delegate the call to it. Otherwise, return an empty array.
      if parent.present? && parent.respond_to?(:member_of_collection_ids)
        parent.member_of_collection_ids
      else
        # Log a warning if the parent presenter is missing or doesn't have the method,
        # indicating a potential data or customization issue.
        Rails.logger.warn "FileSetPresenter #{id} could not find its parent presenter or parent did not respond to `member_of_collection_ids` when rendering." if parent.blank?
        [] # Return an empty array to prevent the view from crashing
      end

      # Rescue any potential errors during this lookup (e.g., parent not found in Solr)
    rescue StandardError => e
      Rails.logger.error "Error getting member_of_collection_ids for FileSetPresenter #{id}: #{e.message}"
      [] # Always return an array to prevent crashes
    end
  end
end

# This line hooks your decorator into the Hyrax::FileSetPresenter class.
# It should be placed after the module definition.
Hyrax::FileSetPresenter.prepend Hyrax::FileSetPresenterDecorator
