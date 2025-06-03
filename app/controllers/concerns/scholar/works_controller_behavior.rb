# frozen_string_literal: true

module Scholar
  # works controller behavior
  # rubocop:disable Metrics/ModuleLength
  module WorksControllerBehavior
    extend ActiveSupport::Concern
    include Hyrax::WorksControllerBehavior
    included do
      before_action :redirect_mismatched_work, only: [:show]

      def redirect_mismatched_work
        curation_concern = ActiveFedora::Base.find(params[:id])
        redirect_to(main_app.polymorphic_path(curation_concern), status: :moved_permanently) and return if curation_concern.class != _curation_concern_type
      end

      # OVERRIDE FROM HYRAX TO INSERT SOLR DOCUMENT INTO DOCUMENT LIST IF THE WORK WAS INGESTED BY THE CURRENT USER
      def search_result_document(search_params)
        _, document_list = search_results(search_params)
        solr_doc = ::SolrDocument.find(params[:id])
        document_list << solr_doc if current_user && solr_doc.depositor == current_user.try(:username)
        return document_list.first unless document_list.empty?

        document_not_found!
      end
    end

  end
  # rubocop:enable Metrics/ModuleLength
end
