# frozen_string_literal: true

class SolrDocument
  include Blacklight::Solr::Document
  include BlacklightOaiProvider::SolrDocument

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
  use_extension(Hydra::ContentNegotiation)

  def system_created
    Time.parse self["system_create_dtsi"]
  end

  # Dates & Times are stored in Solr as UTC but need to be displayed in local timezone
  def modified_date
    Time.parse(self["system_modified_dtsi"]).in_time_zone.to_date
  end

  def create_date
    Time.parse(self["system_create_dtsi"]).in_time_zone.to_date
  end

  def date_uploaded
    Time.parse(self["date_uploaded_dtsi"]).in_time_zone.to_date
  end

  def date_modified
    Time.parse(self["date_modified_dtsi"]).in_time_zone.to_date
  end

  def contact_email
    self["contact_email_tesim"]
  end

  def contact_phone
    self["contact_phone_tesim"]
  end

  def department
    self["department_tesim"]
  end

  def abstract
    self["abstract_tesim"]
  end

  def abstract_search
    self["abstract_tesim"]
  end

  def academic_affiliation
    self["academic_affiliation_tesim"]
  end

  def title
    self["title_tesim"]
  end

  def alternative_title
    self["alternative_title_tesim"]
  end

  def bibliographic_citation
    self["bibliographic_citation_tesim"]
  end

  def conference_location
    self["conference_location_tesim"]
  end

  def conference_name
    self["conference_name_tesim"]
  end

  def event_date
    self["event_date_tesim"]
  end

  def conference_section
    self["conference_section_tesim"]
  end

  def degree_discipline
    self["degree_discipline_tesim"]
  end

  def degree_field
    self["degree_field_tesim"]
  end

  def degree_grantors
    self["degree_grantors_tesim"]
  end

  def degree_level
    self["degree_level_tesim"]
  end

  def degree_name
    self["degree_name_tesim"]
  end

  def contributor_advisor
    self["contributor_advisor_tesim"]
  end

  def contributor_committeemember
    self["contributor_committeemember_tesim"]
  end

  def creator
    self["creator_tesim"]
  end

  def resource_type
    self["resource_type_tesim"]
  end

  def graduation_year
    self["graduation_year_tesim"]
  end

  def rights_statement
    self["rights_statement_tesim"]
  end

  def license
    self["license_tesim"]
  end

  def other_affiliation
    self["other_affiliation_tesim"]
  end

  def date_accepted
    self["date_accepted_tesim"]
  end

  def date_available
    self["date_available_tesim"]
  end

  def date_collected
    self["date_collected_tesim"]
  end

  def date_copyright
    self["date_copyright_tesim"]
  end

  def date_issued
    self["date_issued_tesim"]
  end

  def date_valid
    self["date_valid_tesim"]
  end

  def date_reviewed
    self["date_reviewed_tesim"]
  end

  def digitization_spec
    self["digitization_spec_tesim"]
  end

  def doi
    self["doi_tesim"]
  end

  def editor
    self["editor_tesim"]
  end

  def file_extent
    self["file_extent_tesim"]
  end

  def file_format
    self["file_format_tesim"]
  end

  def has_journal
    self["has_journal_tesim"]
  end

  def has_number
    self["has_number_tesim"]
  end

  def has_volume
    self["has_volume_tesim"]
  end

  def hydrologic_unit_code
    self["hydrologic_unit_code_tesim"]
  end

  def in_series
    self["in_series_tesim"]
  end

  def interactivity_type
    self["interactivity_type_tesim"]
  end

  def is_based_on_url
    self["is_based_on_url_tesim"]
  end

  def is_referenced_by
    self["is_referenced_by_tesim"]
  end

  def isbn
    self["isbn_tesim"]
  end

  def issn
    self["issn_tesim"]
  end

  def learning_resource_type
    self["learning_resource_type_tesim"]
  end

  def replaces
    self["replaces_tesim"]
  end

  def tableofcontents
    self["tableofcontents_tesim"]
  end

  def time_required
    self["time_required_tesim"]
  end

  def typical_age_range
    self["typical_age_range_tesim"]
  end

  def web_of_science_uid
    self["web_of_science_uid_tesim"]
  end

  def additional_information
    self["additional_information_tesim"]
  end

  def embargo_reason
    self["embargo_reason_tesim"]
  end

  def peerreviewed
    self["peerreviewed_tesim"]
  end

  def hasRelatedMediaFragment
    self["hasRelatedMediaFragment_tesim"]
  end

  field_semantics.merge!(
    contributor: %w[contributor_tesim editor_tesim contributor_advisor_tesim contributor_committeemember_tesim],
    coverage: %w['based_near_label_tesim conferenceLocation_tesim'],
    creator: "creator_tesim",
    date: "date_issued_tesim",
    description: "abstract_tesim",
    # department:   'academic_affiliation_tesim',
    format: %w['file_extent_tesim file_format_tesim'],
    identifier: "oai_identifier",
    language: "oai_language",
    license: "license_tesim",
    publisher: "oai_publisher",
    relation: "oai_nested_related_items_label",
    rights: %w[oai_rights],
    # source:       'doi_tesim',
    subject: %w[subject_tesim oai_accademic_affiliation],
    title: "title_tesim",
    type: "resource_type_tesim"
  )

  def [](key)
    return send(key) if %w[oai_identifier oai_source oai_language oai_rights oai_accademic_affiliation oai_publisher].include?(key)
    super
  end

  def oai_publisher
    pubs = []
    if self["publisher_tesim"].present?
      pubs << self["publisher_tesim"]
    end
    if self["degree_grantors_tesim"].present?
      self["degree_grantors_tesim"].each do |item|
        if DegreeGrantorsService.checkterm(item, "term")
          pubs << DegreeGrantorsService.label(item)
        end
      end
    end
    pubs.uniq
  end

  def oai_accademic_affiliation
    aa = []

    if self["academic_affiliation_tesim"].present?
      self["academic_affiliation_tesim"].each do |item|
        if AcademicAffiliationService.checkterm(item, "oai_publish")
          if AcademicAffiliationService.oai_publish(item)
            aa << AcademicAffiliationService.label(item)
          end
        elsif AcademicAffiliationService.checkterm(item, "term")
          aa << AcademicAffiliationService.label(item)
          # default to add item if oai_publish not in file
          # Removed as per review cycle(AJ)
          # else
          #   # add item patron typed in AcademicAffiliation
          #   aa << item
        end
      end
    end
    aa
  end

  def oai_identifier
    if self["has_model_ssim"].first == "Collection"
      Hyrax::Engine.routes.url_helpers.url_for(only_path: false, action: "show", host: CatalogController.blacklight_config.oai[:provider][:repository_url], controller: "hyrax/collections", id: id)
    else
      oai_id = []
      url = Rails.application.routes.url_helpers.url_for(only_path: false, action: "show", host: CatalogController.blacklight_config.oai[:provider][:repository_url], controller: "hyrax/#{self["has_model_ssim"].first.to_s.underscore.pluralize}", id: id)
      oai_id << url
      # Add Download URL
      # if self['hasRelatedMediaFragment_ssim'].try :nonzero?
      begin
        download_url = url.split("/concern")[0]
        download_url = "#{download_url}/downloads/#{self["hasRelatedMediaFragment_ssim"].first}"
        oai_id << download_url
      rescue Exception => e
        ""
      end
      if self["doi_tesim"].present? # .try :nonzero?
        oai_id << "#{self["doi_tesim"].first}"
      end
      oai_id
    end
  end

  def oai_rights
    oai_rights = []
    begin
      oai_rights << RightsService.label(self["rights_statement_tesim"].first)
    rescue Exception => e
      ""
    end
    begin
      oai_rights << LicenseService.label(self["license_tesim"].first)
    rescue Exception => e
      ""
    end
    oai_rights
  end

  def oai_subject
    oai_subject = []
    begin
      oai_subject << self["subject_tesim"]
    rescue Exception => e
      ""
    end
    begin
      # Add Academic Affiliation
      oai_subject << self["academic_affiliation_tesim"]
    rescue Exception => e
      ""
    end
    oai_subject
  end

  def oai_language
    LanguageService.label(self["language_tesim"].first)
  rescue Exception => e
    ""
  end
end
