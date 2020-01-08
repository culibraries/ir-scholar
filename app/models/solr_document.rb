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

  # CU Boulder Modifications
  # def self.solrized_methods(property_names)
  #   property_names.each do |property_name|
  #     define_method property_name.to_sym do
  #       values = self[Solrizer.solr_name(property_name)]
  #       if values.respond_to?(:each)
  #         values.reject(&:blank?)
  #       else
  #         values
  #       end
  #     end
  #   end
  # end

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
  def abstract_search
    self[Solrizer.solr_name('abstract')]
  end
  def academic_affiliation
    self[Solrizer.solr_name('academic_affiliation')]
  end
  def title
    self[Solrizer.solr_name('title')]
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
  def event_date
    self[Solrizer.solr_name('event_date')]
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
  def creator
    self[Solrizer.solr_name('creator')]
  end
  def academic_affiliation
    self[Solrizer.solr_name('academic_affiliation')]
  end
  def resource_type
    self[Solrizer.solr_name('resource_type')]
  end
  def graduation_year
    self[Solrizer.solr_name('graduation_year')]
  end
  def rights_statement
    self[Solrizer.solr_name('rights_statement')]
  end
  def other_affiliation
    self[Solrizer.solr_name('other_affiliation')]
  end
  def date_accepted
    self[Solrizer.solr_name('date_accepted')]
  end
  def date_available
    self[Solrizer.solr_name('date_available')]
  end
  def date_collected
    self[Solrizer.solr_name('date_collected')]
  end
  def date_copyright
    self[Solrizer.solr_name('date_copyright')]
  end
  def date_issued
    self[Solrizer.solr_name('date_issued')]
  end
  def date_valid
    self[Solrizer.solr_name('date_valid')]
  end
  def date_reviewed
    self[Solrizer.solr_name('date_reviewed')]
  end
  def digitization_spec
    self[Solrizer.solr_name('digitization_spec')]
  end
  def doi
    self[Solrizer.solr_name('doi')]
  end
  def editor
    self[Solrizer.solr_name('editor')]
  end
  def file_extent
    self[Solrizer.solr_name('file_extent')]
  end
  def file_format
    self[Solrizer.solr_name('file_format')]
  end
  def graduation_year
    self[Solrizer.solr_name('graduation_year')]
  end
  def has_journal
    self[Solrizer.solr_name('has_journal')]
  end
  def has_number
    self[Solrizer.solr_name('has_number')]
  end
  def has_volume
    self[Solrizer.solr_name('has_volume')]
  end
  def hydrologic_unit_code
    self[Solrizer.solr_name('hydrologic_unit_code')]
  end
  def in_series
    self[Solrizer.solr_name('in_series')]
  end
  def interactivity_type
    self[Solrizer.solr_name('interactivity_type')]
  end
  def is_based_on_url
    self[Solrizer.solr_name('is_based_on_url')]
  end
  def is_referenced_by
    self[Solrizer.solr_name('is_referenced_by')]
  end
  def isbn
    self[Solrizer.solr_name('isbn')]
  end
  def issn
    self[Solrizer.solr_name('issn')]
  end
  def learning_resource_type
    self[Solrizer.solr_name('learning_resource_type')]
  end
  def other_affiliation
    self[Solrizer.solr_name('other_affiliation')]
  end
  def replaces
    self[Solrizer.solr_name('replaces')]
  end
  def tableofcontents
    self[Solrizer.solr_name('tableofcontents')]
  end
  def time_required
    self[Solrizer.solr_name('time_required')]
  end
  def typical_age_range
    self[Solrizer.solr_name('typical_age_range')]
  end
  def web_of_science_uid
    self[Solrizer.solr_name('web_of_science_uid')]
  end
  def additional_information
    self[Solrizer.solr_name('additional_information')]
  end
  def embargo_reason
    self[Solrizer.solr_name('embargo_reason')]
  end
  def peerreviewed
    self[Solrizer.solr_name('peerreviewed')]
  end
  def file_extent
    self[Solrizer.solr_name('file_extent')]
  end
  def file_format
    self[Solrizer.solr_name('file_format')]
  end
end
