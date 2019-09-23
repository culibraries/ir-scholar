# Generated via
#  `rails generate hyrax:work DefaultWork`
module Scholar
    # Generated form for DefaultWork
    class EtdWorkForm < Hyrax::Forms::WorkForm

      self.terms = [:title, :creator, :academic_affiliation, :department, :resource_type, :degree_level, :graduation_year, :rights_statement,
        :contributor_advisor,
        :contributor_committeemember,
        :date_issued, 
        :abstract,
        :degree_grantors,
        :publisher,
        :alt_title,
        :subject,
        :keyword, 
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
        :admin_set_id, :replaces]
      self.required_fields = [:title, :creator,:academic_affiliation,:department, :resource_type, :degree_level,:graduation_year, :rights_statement]
      #print self.required_fields
      #puts self.required_fields.delete(:license)
      # def self.multiple?(field)
      #   if [:title].include? field.to_sym
      #     false
      #   else
      #     super
      #   end
      # end
  
      # def self.model_attributes(_)
      #   attrs = super
      #   attrs[:title] = Array(attrs[:title]) if attrs[:title]
      #   attrs
      # end
  
      # def title
      #   super.first || ""
      # end
    end
  end
