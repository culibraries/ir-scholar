namespace :basic_import do
    desc 'Ingest sample data'
    task sample: [:environment] do
      csv_file = Rails.root.join('app', 'importers', 'csv.csv')
      ModularImporter.new(csv_file).import
    end
  end