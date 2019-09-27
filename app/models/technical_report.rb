# Generated via
#  `rails generate hyrax:work TechnicalReport`
class TechnicalReport < ActiveFedora::Base
  include ::Hyrax::WorkBehavior

  self.indexer = TechnicalReportIndexer
  # Change this to restrict which works can be added as a child.
  # self.valid_child_concerns = []
  validates :title, presence: { message: 'Your work must have a title.' }

  #Reports
  property :editor, predicate: ::RDF::Vocab::BIBO.editor do |index|
    index.as :stored_searchable
  end
  property :peerreviewed, predicate: ::RDF::URI('http://purl.org/ontology/bibo/peerReviewed'), multiple: false do |index|
    index.as :stored_searchable, :facetable
  end
  property :other_affiliation, predicate: ::RDF::URI('http://vivoweb.org/ontology/core#Department') do |index|
    index.as :stored_searchable, :facetable
  end
  property :is_referenced_by, predicate: ::RDF::Vocab::DC.isReferencedBy do |index|
    index.as :stored_searchable
  end
  #error maybe
  property :contributor, predicate: ::RDF::Vocab::DC11.contributor do |index|
    index.as :stored_searchable
  end
  #common
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
  #include Scholar::DefaultMetadata
end
