# Generated via
#  `rails generate hyrax:work DefaultWork`
module Scholar
    # Generated form for DefaultWork
    class ArticleWorkForm < Hyrax::Forms::WorkForm
      self.terms = [:title, :creator,:academic_affiliation, :resource_type, :rights_statement,
        :date_issued,
        :abstract,
        :has_journal,
        :has_number,
        :has_volume,
        :issn,
        :publisher,
        :doi,
        :peerreviewed,
        :editor,
        :contributor,
        :alt_title,
        :identifier,
        :in_series,
        :bibliographic_citation,
        :license,
        :based_near,
        :language,
        :other_affiliation,
        :subject, 
        :embargo_reason,
        :is_referenced_by,
        :additional_information,
        :replaces,
        :related_url,
        :representative_id, :thumbnail_id, :rendering_ids, :files,
        :visibility_during_embargo, :embargo_release_date, :visibility_after_embargo,
        :visibility_during_lease, :lease_expiration_date, :visibility_after_lease,
        :visibility, :ordered_member_ids, :in_works_ids,
        :member_of_collection_ids, 
        :admin_set_id ]
      self.required_fields = [:title, :creator,:academic_affiliation, :resource_type, :rights_statement]
      
    end
  end