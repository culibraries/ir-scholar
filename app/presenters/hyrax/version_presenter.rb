# frozen_string_literal: true

module Hyrax
  class VersionPresenter
    attr_reader :version, :current

    def initialize(version)
      @version = version
      @current = false
    end

    delegate :label, :uri, to: :version
    alias_method :current?, :current

    def current!
      @current = true
    end

    def label
      version.try(:label) || ""
    end

    def uri
      version.try(:uri) || ""
    end

    def created
      @created ||= version.created.in_time_zone.to_formatted_s(:long_ordinal)
    end

    def committer
      version.try(:committer) || version.try(:version_id) || ""
      # Hyrax::VersionCommitter
      #   .find_by(version_id: version.version_id)
      #   &.committer_login
    end
  end
end
