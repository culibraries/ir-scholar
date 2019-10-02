# Generated via
#  `rails generate hyrax:work DefaultWork`
module Scholar
    # Generated form for DefaultWork
    class GeneralWorkForm < Hyrax::Forms::WorkForm
      # include Scholar::DefaultWorkFormBehavior
      # include DefaultWorkFormBehavior
      # extend ActiveSupport::Concern
      #attr_accessor :current_user

      # admin_visability=[]
      # admin_visability << %i[keyword,embargo_reason,replaces] if current_user.admin?
      
      self.terms = [:title, :creator, :academic_affiliation,:resource_type, :rights_statement,
        :conference_location,
        :conference_name,
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
        :date_available,
        :is_referenced_by,
        :additional_information,
        :related_url,
        :embargo_reason,
        :replaces,
        :representative_id, :thumbnail_id, :rendering_ids, :files,
        :visibility_during_embargo, :embargo_release_date, :visibility_after_embargo,
        :visibility_during_lease, :lease_expiration_date, :visibility_after_lease,
        :visibility, :ordered_member_ids, :in_works_ids,
        :member_of_collection_ids, 
        :admin_set_id ]
        # self.terms << admin_visability 

    end
  end
 