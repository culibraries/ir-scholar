# frozen_string_literal: true

module Hyrax
  ##
  # @api public
  class VersionListPresenter
    include Enumerable

    attr_reader :versioning_service

    ##
    # @param service [Hyrax::VersioningService]
    def initialize(service)
      @versioning_service = service
    end

    ## CUBL Change:
    # Force the use of ActiveFedora instead of the agnostic Wings adapter.
    # Wings wasn't able to retrieve all of a version's information
    ##
    # @param [Object] an object representing the File Set
    # @return [Hyrax::VersionListPresenter] an enumerable of presenters for the
    #   relevant file versions.
    # @raise [ArgumentError] if we can't build an enumerable
    ##
    def self.for(file_set:)
      original_file = ActiveFedora::Base.find(file_set.id.to_s)&.original_file
      new(Hyrax::VersioningService.new(resource: original_file))
    rescue NoMethodError => e
      Hyrax.logger.error e.message
      raise ArgumentError
    end

    delegate :each, :empty?, to: :wrapped_list
    delegate :supports_multiple_versions?, to: :versioning_service

    private

    def wrapped_list
      @wrapped_list ||=
        begin
          presenters = @versioning_service.versions.map { |v| Hyrax::VersionPresenter.new(v) } # wrap each item in a presenter
          if presenters.first&.version&.respond_to?(:created)
            presenters.sort! { |a, b| b.version.created <=> a.version.created } if presenters.first&.version.respond_to?(:created) # sort list of versions based on creation date
          else
            presenters.reverse!
          end
          presenters.tap { |l| l.first.try(:current!) } # set the first version to the current version
        end
    end
  end
end
