# Generated via
#  `rails generate hyrax:work DefaultWork`
module Scholar
    # Generated form for DefaultWork
    class ArticleWorkForm < Hyrax::Forms::WorkForm
      self.terms += [
        :editor,
        :has_journal,
        :has_number,
        :has_volume,
        :is_referenced_by,
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
        :rights_statement,
        :license ]
      self.required_fields += [ :license, :creator, :academic_affiliation, :resource_type, :rights_statement]
    end
  end

