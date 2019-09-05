# frozen_string_literal: true
class SolrDocument
  include Blacklight::Solr::Document
  include Blacklight::Gallery::OpenseadragonSolrDocument

  # Adds Hyrax behaviors to the SolrDocument.
  include Hyrax::SolrDocumentBehavior


  # self.unique_key = 'id'

  # Email uses the semantic field mappings below to generate the body of an email.
  SolrDocument.use_extension(Blacklight::Document::Email)

  # SMS uses the semantic field mappings below to generate the body of an SMS email.
  SolrDocument.use_extension(Blacklight::Document::Sms)

  # DublinCore uses the semantic field mappings below to assemble an OAI-compliant Dublin Core document
  # Semantic mappings of solr stored fields. Fields may be multi or
  # single valued. See Blacklight::Document::SemanticFields#field_semantics
  # and Blacklight::Document::SemanticFields#to_semantic_values
  # Recommendation: Use field names from Dublin Core
  use_extension(Blacklight::Document::DublinCore)

  # Do content negotiation for AF models. 

  use_extension( Hydra::ContentNegotiation )

  ## CU Boulder Modifications
  def self.solrized_methods(property_names)
    property_names.each do |property_name|
      define_method property_name.to_sym do
        values = self[Solrizer.solr_name(property_name)]
        if values.respond_to?(:each)
          values.reject(&:blank?)
        else
          values
        end
      end
    end
  end


  def contact_email
    self[Solrizer.solr_name('contact_email')]
  end
  def contact_phone
    self[Solrizer.solr_name('contact_phone')]
  end
  def department
    self[Solrizer.solr_name('department')]
  end
  def abstract
    self[Solrizer.solr_name('abstract')]
  end
  def academic_affiliation
    self[Solrizer.solr_name('academic_affiliation')]
  end
  def alt_title
    self[Solrizer.solr_name('alt_title')]
  end
  def bibliographic_citation
    self[Solrizer.solr_name('bibliographic_citation')]
  end
  def conference_location
    self[Solrizer.solr_name('conference_location')]
  end
  def conference_name
    self[Solrizer.solr_name('conference_name')]
  end
  def conference_section
    self[Solrizer.solr_name('conference_section')]
  end
  def degree_discipline
    self[Solrizer.solr_name('degree_discipline')]
  end
  def degree_field
    self[Solrizer.solr_name('degree_field')]
  end
  def degree_grantors
    self[Solrizer.solr_name('degree_grantors')]
  end
  def degree_level
    self[Solrizer.solr_name('degree_level')]
  end
  def degree_name
    self[Solrizer.solr_name('degree_name')]
  end
  def contributor_advisor
    self[Solrizer.solr_name('contributor_advisor')]
  end
  def contributor_committeemember
    self[Solrizer.solr_name('contributor_committeemember')]
  end
  
  solrized_methods %w[
    date_accepted
    date_available
    date_collected
    date_copyright
    date_issued
    date_valid
    date_reviewed
    digitization_spec
    doi
    editor
    file_extent
    file_format
    graduation_year
    has_journal
    has_number
    has_volume
    hydrologic_unit_code
    in_series
    interactivity_type
    is_based_on_url
    is_referenced_by
    isbn
    issn
    learning_resource_type
    other_affiliation
    replaces
    tableofcontents
    time_required
    typical_age_range
    web_of_science_uid
  ]

end
