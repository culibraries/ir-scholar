require 'csv'
#require 'hydra_access'
class CsvImporter
  def initialize(metadata,email)
    @metadata = JSON.parse(metadata)
    @user = User.find_by_user_key(email)
    #::User.batch_user
  end

  def import
    #CSV.foreach(@file) do |row|
      data= @metadata
      etd = GraduateThesisOrDissertation.new
      #image = Image.new
      etd.title = [data['title']]
      etd.creator = ["Stacy, Mark"]
      etd.academic_affiliation = ["Accounting"]
      etd.graduation_year = "2015"
      etd.resource_type = ["Dissertation"]
      etd.rights_statement = ["http://rightsstatements.org/vocab/InC/1.0/"]
      etd.degree_level = "Doctoral"
      etd.degree_grantors = "http://id.loc.gov/authorities/names/n50000485"
      etd.admin_set_id = "admin_set/default"
      #etd.admin_set_id = "3197xm04j"
      #etd.agreement = "1"
      #image.source = [row[2]]
      etd.visibility = "open"
      etd.depositor = @user.email
      # Attach the image file and run it through the actor stack
      # Try entering Hyrax::CurationConcern.actor on a console to see all of the
      # actors this object will run through.
      etd_binary = File.open("#{::Rails.root}/tmp/#{data['filename']}")
      uploaded_file = Hyrax::UploadedFile.create(user: @user, file: etd_binary)
      byebug
      attributes_for_actor = { uploaded_files: [uploaded_file.id] }
      env = Hyrax::Actors::Environment.new(etd, ::Ability.new(@user), attributes_for_actor)
      Hyrax::CurationConcern.actor.create(env)
      etd_binary.close
    #end
  end
end

if __FILE__ == $0
    # Importer requires two arguments: 1. csv file 2. email of user
    dd=CsvImporter.new ARGV[0],ARGV[1]
    dd.import
end