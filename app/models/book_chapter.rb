# Generated via
#  `rails generate hyrax:work BookChapter`
class BookChapter < ActiveFedora::Base
  include ::Hyrax::WorkBehavior

  self.indexer = BookChapterIndexer
  # Change this to restrict which works can be added as a child.
  # self.valid_child_concerns = []
  validates :date_issued, :allow_blank => true, 
    format: { with: /([12]\d{3}-(0[1-9]|1[0-2])-(0[1-9]|[12]\d|3[01]))|([12]\d{3}-(0[1-9]|1[0-2]))|(^[0-9]{4}$)/, 
    message: "Date format: yyyy-mm-dd, yyyy-mm, yyyy"
  } 
  validates :date_available, :allow_blank => true, 
    format: { with: /([12]\d{3}-(0[1-9]|1[0-2])-(0[1-9]|[12]\d|3[01]))|([12]\d{3}-(0[1-9]|1[0-2]))|(^[0-9]{4}$)/, 
    message: "Date format: yyyy-mm-dd, yyyy-mm, yyyy"
  } 
  
  validates :title, presence: { message: 'Your work must have a title.' }

  # validates :date_available, format: { with: /(0[1-9]|1[0-2])/(0[1-9]|[12]\d|3[01])/([12]\d{3})/ ,
  #           message:'Date Availble format: mm/dd/yyyy '}


  #Book Chapter
  property :isbn, predicate: ::RDF::Vocab::Identifiers.isbn do |index|
    index.as :stored_searchable
  end
  property :peerreviewed, predicate: ::RDF::URI('http://purl.org/ontology/bibo/peerReviewed'), multiple: false do |index|
    index.as :stored_searchable, :facetable
  end
  property :in_series, predicate: ::RDF::URI.new('http://lsdis.cs.uga.edu/projects/semdis/opus#in_series') do |index|
    index.as :stored_searchable
  end
  property :other_affiliation, predicate: ::RDF::URI('http://vivoweb.org/ontology/core#Department') do |index|
    index.as :stored_searchable, :facetable
  end
  property :is_referenced_by, predicate: ::RDF::Vocab::DC.isReferencedBy do |index|
    index.as :stored_searchable
  end
  property :editor, predicate: ::RDF::Vocab::BIBO.editor do |index|
    index.as :stored_searchable
  end
  #error maybe
  # property :contributor, predicate: ::RDF::Vocab::DC11.contributor do |index|
  #   index.as :stored_searchable
  # end
  property :date_available, predicate: ::RDF::Vocab::DC.available, multiple: false do |index|
    index.as :stored_searchable, :facetable
  end
  
  property :embargo_reason, predicate: ::RDF::Vocab::DC.accessRights, multiple: false do |index|
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
  property :file_extent, predicate: ::RDF::Vocab::DC.extent do |index|
    index.as :stored_searchable
  end
  property :file_format, predicate: ::RDF::Vocab::DC.FileFormat do |index|
    index.as :stored_searchable, :facetable
  end
  # property :rights_statement, predicate: ::RDF::Vocab::EDM.rights do |index|
  #   index.as :stored_searchable, :facetable
  # end

  # This must be included at the end, because it finalizes the metadata
  # schema (by adding accepts_nested_attributes)
  include ::Hyrax::BasicMetadata
  #include Scholar::DefaultMetadata
end
