# Generated via
#  `rails generate hyrax:work Article`
class Article < ActiveFedora::Base
  include ::Hyrax::WorkBehavior

  self.indexer = ArticleIndexer
  # Change this to restrict which works can be added as a child.
  # self.valid_child_concerns = []
  validates :title, presence: { message: 'Your work must have a title.' }

  property :editor, predicate: ::RDF::Vocab::BIBO.editor do |index|
    index.as :stored_searchable
  end

  property :has_journal, predicate: ::RDF::URI.new('http://purl.org/net/nknouf/ns/bibtex#hasJournal'), multiple: false do |index|
    index.as :stored_searchable, :facetable
  end

  property :has_number, predicate: ::RDF::URI.new('http://purl.org/net/nknouf/ns/bibtex#hasNumber'), multiple: false do |index|
    index.as :stored_searchable
  end

  property :has_volume, predicate: ::RDF::URI.new('http://purl.org/net/nknouf/ns/bibtex#hasVolume'), multiple: false do |index|
    index.as :stored_searchable
  end

  property :is_referenced_by, predicate: ::RDF::Vocab::DC.isReferencedBy do |index|
    index.as :stored_searchable
  end

  property :web_of_science_uid, predicate: ::RDF::URI.new('http://opaquenamespace.org/ns/webOfScienceUid'), multiple: false do |index|
    index.as :stored_searchable
  end
   
  # This must be included at the end, because it finalizes the metadata
  # schema (by adding accepts_nested_attributes)
  include ::Hyrax::BasicMetadata
  #include Scholar::DefaultMetadata
end
