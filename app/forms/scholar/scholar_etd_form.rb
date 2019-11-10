# Generated via
#  `rails generate hyrax:work DefaultWork`
module Scholar
    # Generated form for DefaultWork
    class EtdWorkForm < Hyrax::Forms::WorkForm

      self.terms = [:title, :creator, :academic_affiliation, :resource_type, :degree_level, 
        :graduation_year, :rights_statement,
        :contributor_advisor,
        :contributor_committeemember,
        :contributor,
        :date_issued, 
        :abstract,
        :degree_name,
        :degree_grantors,
        :publisher,
        :alt_title,
        :subject,
        :doi,
        :bibliographic_citation,
        :additional_information,
        :license,
        :language, :identifier, :based_near, :related_url,
        :representative_id, :thumbnail_id, :rendering_ids, :files,
        :visibility_during_embargo, :embargo_release_date, :visibility_after_embargo,
        :visibility_during_lease, :lease_expiration_date, :visibility_after_lease,
        :visibility, :ordered_member_ids, :in_works_ids,
        :member_of_collection_ids, 
        :admin_set_id, :replaces,:embargo_reason]
      self.required_fields = [:title, :creator,:academic_affiliation, 
        :resource_type, :degree_level,:graduation_year, :rights_statement]
      
    end
  end
