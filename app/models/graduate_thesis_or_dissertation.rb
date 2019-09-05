# Generated via
#  `rails generate hyrax:work GraduateThesisOrDissertation`
class GraduateThesisOrDissertation < ActiveFedora::Base
  include ::Hyrax::WorkBehavior
  
  self.indexer = GraduateThesisOrDissertationIndexer
  # Change this to restrict which works can be added as a child.
  # self.valid_child_concerns = []
  validates :title, presence: { message: 'Your work must have a title.' }

  # property :contributor_advisor, predicate: ::RDF::Vocab::MARCRelators.ths do |index|
  #   index.as :stored_searchable, :facetable
  # end

  # property :contributor_committeemember, predicate: ::RDF::Vocab::MARCRelators.dgs do |index|
  #   index.as :stored_searchable, :facetable
  # end

  # property :degree_discipline, predicate: ::RDF::URI.new('http://http://dbpedia.org/ontology/academicDiscipline') do |index|
  #   index.as :stored_searchable
  # end

  # property :degree_grantors, predicate: ::RDF::Vocab::MARCRelators.dgg, multiple: false do |index|
  #   index.as :stored_searchable
  # end

  # accessor value used by AddOtherFieldOptionActor to persist "Other" values provided by the user
  #attr_accessor :degree_grantors_other

  # property :graduation_year, predicate: ::RDF::URI.new('http://www.rdaregistry.info/Elements/w/#P10215'), multiple: false do |index|
  #   index.as :stored_searchable, :facetable
  # end

  # This must be included at the end, because it finalizes the metadata
  # schema (by adding accepts_nested_attributes)
  include Scholar::EtdMetadata
  
  
  
end
