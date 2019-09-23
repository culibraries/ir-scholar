# Generated via
#  `rails generate hyrax:work GraduateThesisOrDissertation`
class GraduateThesisOrDissertation < ActiveFedora::Base
  include ::Hyrax::WorkBehavior
  # after_initialize :init

  # def init
  #   self.admin_set_id ||= "t435gc96m"
    
  #   #self.status = ACTIVE unless self.status
  # end

  self.indexer = GraduateThesisOrDissertationIndexer
  # Change this to restrict which works can be added as a child.
  # self.valid_child_concerns = []

  validates :title, presence: { message: 'Your work must have a title.' }

  # property :title, predicate: ::RDF::Vocab::DC.title, multiple: false do |index|
  #   index.as :stored_searchable, :facetable
  # end
  property :department, predicate: ::RDF::URI.new("http://lib.colorado.edu/departments"), multiple: false do |index|
    index.as :stored_searchable, :facetable
  end

  property :contributor_advisor, predicate: ::RDF::Vocab::MARCRelators.ths do |index|
    index.as :stored_searchable, :facetable
  end

  property :contributor_committeemember, predicate: ::RDF::Vocab::MARCRelators.dgs do |index|
    index.as :stored_searchable, :facetable
  end

  # property :degree_discipline, predicate: ::RDF::URI.new('http://dbpedia.org/ontology/academicDiscipline') do |index|
  #   index.as :stored_searchable
  # end
  property :abstract, predicate: ::RDF::Vocab::DC.abstract do |index|
    index.as :stored_searchable
  end
  property :degree_grantors, predicate: ::RDF::Vocab::MARCRelators.dgg, multiple: false do |index|
    index.as :stored_searchable
  end
  property :degree_level, predicate: ::RDF::URI.new('http://purl.org/NET/UNTL/vocabularies/degree-information/#level'), multiple: false do |index|
    index.as :stored_searchable, :facetable
  end
  # property :degree_name, predicate: ::RDF::URI.new('http://purl.org/ontology/bibo/ThesisDegree') do |index|
  #   index.as :stored_searchable, :facetable
  # end
  # accessor value used by AddOtherFieldOptionActor to persist "Other" values provided by the user
  #attr_accessor :degree_grantors_other

  property :graduation_year, predicate: ::RDF::URI.new('http://www.rdaregistry.info/Elements/w/#P10215'), multiple: false do |index|
    index.as :stored_searchable, :facetable
  end

  property :doi, predicate: ::RDF::Vocab::Identifiers.doi, multiple: false do |index|
    index.as :stored_searchable, :facetable
  end
  property :replaces, predicate: ::RDF::Vocab::DC.replaces, multiple: false do |index|
    index.as :stored_searchable
  end
  property :academic_affiliation, predicate: ::RDF::URI('http://vivoweb.org/ontology/core#AcademicDepartment') do |index|
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
  #include Scholar::EtdMetadata
  include ::Hyrax::BasicMetadata
  
  
  
end
