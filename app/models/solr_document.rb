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
  def system_created
    Time.parse self['system_create_dtsi']
  end

  # Dates & Times are stored in Solr as UTC but need to be displayed in local timezone
  def modified_date
    Time.parse(self['system_modified_dtsi']).in_time_zone.to_date
  end

  def create_date
    Time.parse(self['system_create_dtsi']).in_time_zone.to_date
  end

  def date_uploaded
    Time.parse(self['date_uploaded_dtsi']).in_time_zone.to_date
  end

  def date_modified
    Time.parse(self['date_modified_dtsi']).in_time_zone.to_date
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
  def hasRelatedMediaFragment
    self[Solrizer.solr_name('hasRelatedMediaFragment')]
  end

  field_semantics.merge!(
    contributor:  %w[contributor_tesim editor_tesim contributor_advisor_tesim contributor_committeemember_tesim ],
    coverage:     %w['based_near_label_tesim conferenceLocation_tesim'],
    creator:      'creator_tesim',
    date:         'date_issued_tesim',
    description:  'abstract_tesim',
    #department:   'academic_affiliation_tesim',
    format:       %w['file_extent_tesim file_format_tesim'],
    identifier:   'oai_identifier',
    language:     'oai_language',
    publisher:    'oai_publisher',
    relation:     'oai_nested_related_items_label',
    rights:       %w[oai_rights],
    #source:       'doi_tesim', 
    subject:      %w[subject_tesim oai_accademic_affiliation],
    title:        'title_tesim',
    type:         'resource_type_tesim'
  )
  def [](key)
      return send(key) if %w[oai_identifier oai_source oai_language oai_rights oai_accademic_affiliation oai_publisher].include?(key)
      super
  end
  def oai_publisher
    pubs=[]
    if self['publisher_tesim'].present?
      pubs << self['publisher_tesim']
    end
    if self['degree_grantors_tesim'].present?
      self['degree_grantors_tesim'].each do |item|
        if DegreeGrantorsService.checkterm(item,'term')
          pubs << DegreeGrantorsService.label(item)
        end
      end
    end
    pubs.uniq
  end
  def oai_accademic_affiliation
    aa =[]
    
    if self['academic_affiliation_tesim'].present?
      self['academic_affiliation_tesim'].each do |item|
        if AcademicAffiliationService.checkterm(item,'oai_publish')
          if AcademicAffiliationService.oai_publish(item)
            aa << AcademicAffiliationService.label(item)
          end
        else
          if AcademicAffiliationService.checkterm(item,'term')
            #default to add item if oai_publish not in file
            aa << AcademicAffiliationService.label(item)
          # Removed as per review cycle(AJ)
          # else  
          #   # add item patron typed in AcademicAffiliation
          #   aa << item
          end
        end
      end
    end
    aa
  end
  def oai_identifier
    if self['has_model_ssim'].first.to_s == 'Collection'
      Hyrax::Engine.routes.url_helpers.url_for(only_path: false, action: 'show', host: CatalogController.blacklight_config.oai[:provider][:repository_url], controller: 'hyrax/collections', id: id)
    else
      oai_id = []
      url = Rails.application.routes.url_helpers.url_for(only_path: false, action: 'show', host: CatalogController.blacklight_config.oai[:provider][:repository_url], controller: "hyrax/#{self['has_model_ssim'].first.to_s.underscore.pluralize}", id: id)
      oai_id << url
      # Add Download URL
      #if self['hasRelatedMediaFragment_ssim'].try :nonzero?
      begin
        download_url = url.split('/concern')[0]
        download_url="#{download_url}/downloads/#{self['hasRelatedMediaFragment_ssim'].first.to_s}"
        oai_id << download_url
      rescue Exception => e
        ""
      end
      if self['doi_tesim'].present? #.try :nonzero?
        oai_id << "#{self['doi_tesim'].first.to_s}"
      end
      oai_id
    end
  end
  def oai_rights
    oai_rights = []
    begin
      oai_rights << RightsService.label(self['rights_statement_tesim'].first.to_s)
    rescue Exception => e
      ""
    end
    begin
      oai_rights << LicenseService.label(self['license_tesim'].first.to_s)
    rescue Exception => e
      ""
    end
    oai_rights
  end
  def oai_subject
      oai_subject = []
      begin
        oai_subject << self['subject_tesim']
      rescue Exception => e
        ""
      end
      begin
      #Add Academic Affiliation
        oai_subject << self['academic_affiliation_tesim']
      rescue Exception => e
        ""
      end
      oai_subject
  end

  def oai_language
    
    begin
      LanguageService.label(self['language_tesim'].first.to_s)
    rescue Exception => e
      ""
    end
    
  end

end
