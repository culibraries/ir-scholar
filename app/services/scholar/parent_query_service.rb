# frozen_string_literal: true

module Scholar
  # Query for parent
  class ParentQueryService
    def self.query_parents_for_id(child_id)
      ActiveFedora::SolrService.get("member_ids_ssim:#{child_id}", rows: 1_000)["response"]["docs"]
    end
  end
end
