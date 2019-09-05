# Generated via
#  `rails generate hyrax:work DefaultWork`
module Scholar
    # Generated form for DefaultWork
    class EtdWorkForm < Hyrax::Forms::WorkForm
      self.terms += [
        :contributor_advisor,
        :contributor_committeemember,
        :graduation_year,
        :degree_grantors,
        :degree_field,
        :degree_name,
        :resource_type, 
        :abstract,
        :academic_affiliation,
        :additional_information,
        :alt_title,
        :bibliographic_citation,
        :conference_location,
        :conference_name,
        :contributor,
        :creator,
        :date_available,
        :date_created,
        :date_issued,
        :doi,
        :embargo_reason,
        :file_extent,
        :file_format,
        :identifier,
        :in_series,
        :isbn,
        :issn,
        :keyword,
        :language,
        :other_affiliation,
        :peerreviewed,
        :publisher,
        :replaces,
        :resource_type,
        :rights_statement]
      self.required_fields += [ :graduation_year, :degree_field, :degree_name,:license, :creator, :academic_affiliation, :resource_type, :rights_statement]
    end
  end
# :graduation_year,
# :degree_grantors,
# 