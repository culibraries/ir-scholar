require 'zizia'

class MyImporter
  def initialize(csv_file)
    @csv_file = csv_file
    raise "Cannot find expected input file #{csv_file}" unless File.exist?(csv_file)
  end

  def import
    attrs = {
      collection_id: '',     # pass a collection id to the record importer and all records will be added to that collection
      depositor_id: 'dutr5288@colorado.edu',       # pass a Hyrax user_key here and that Hyrax user will own all objects created during this import
      deduplication_field: 'identifier' # pass a field with a persistent identifier (e.g., ARK) and it will check to see if a record with that identifier already
    }                                   # exists, update its metadata if so, and only if it doesn't find a record with that identifier will it make a new object.

    file = File.open(@csv_file)
    parser = Zizia::CsvParser.new(file: file)
    record_importer = Zizia::HyraxRecordImporter.new(attributes: attrs)
    Zizia::Importer.new(parser: parser, record_importer: record_importer).import
    file.close # unless a block is passed to File.open, the file must be explicitly closed
  end
end