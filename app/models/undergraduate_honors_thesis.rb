# Generated via
#  `rails generate hyrax:work UndergraduateHonorsThesis`
class UndergraduateHonorsThesis < ActiveFedora::Base
  include ::Hyrax::WorkBehavior

  self.indexer = UndergraduateHonorsThesisIndexer
  # Change this to restrict which works can be added as a child.
  # self.valid_child_concerns = []
  validates :title, presence: { message: 'Your work must have a title.' }
  
  property :contributor, predicate: ::RDF::Vocab::DC11.contributor do |index|
    index.as :stored_searchable
  end
  property :contributor_advisor, predicate: ::RDF::Vocab::MARCRelators.ths do |index|
    index.as :stored_searchable, :facetable
  end

  property :contributor_committeemember, predicate: ::RDF::Vocab::MARCRelators.dgs do |index|
    index.as :stored_searchable, :facetable
  end

  
  property :degree_grantors, predicate: ::RDF::Vocab::MARCRelators.dgg, multiple: false do |index|
    index.as :stored_searchable
  end
  property :degree_level, predicate: ::RDF::URI.new('http://purl.org/NET/UNTL/vocabularies/degree-information/#level'), multiple: false do |index|
    index.as :stored_searchable, :facetable
  end
  # Removed Degree Name for degree level
  # property :degree_name, predicate: ::RDF::URI.new('http://purl.org/ontology/bibo/ThesisDegree') do |index|
  #   index.as :stored_searchable, :facetable
  # end
  property :graduation_year, predicate: ::RDF::URI.new('http://www.rdaregistry.info/Elements/w/#P10215'), multiple: false do |index|
    index.as :stored_searchable, :facetable
  end

  #Common
  property :abstract, predicate: ::RDF::Vocab::DC.abstract do |index|
    index.as :stored_searchable
  end
  property :doi, predicate: ::RDF::Vocab::Identifiers.doi, multiple: false do |index|
    index.as :stored_searchable, :facetable
  end
  property :replaces, predicate: ::RDF::Vocab::DC.replaces, multiple: false do |index|
    index.as :stored_searchable
  end
  property :academic_affiliation, predicate: ::RDF::URI('http://vivoweb.org/ontology/core#AcademicDepartment'), multiple: true do |index|
    index.as :stored_searchable, :facetable
  end
  property :date_issued, predicate: ::RDF::Vocab::DC.issued, multiple: false do |index|
    index.as :stored_searchable, :facetable
  end
  property :alt_title, predicate: ::RDF::Vocab::DC.alternative do |index|
    index.as :stored_searchable
  end
  property :additional_information, predicate: ::RDF::Vocab::DC.description do |index|
    index.as :stored_searchable
  end
  property :rights_statement, predicate: ::RDF::Vocab::EDM.rights do |index|
    index.as :stored_searchable, :facetable
  end

  # This must be included at the end, because it finalizes the metadata
  # schema (by adding accepts_nested_attributes)
  include ::Hyrax::BasicMetadata
  #include Scholar::EtdMetadata
  #include Scholar::DefaultMetadata
end
