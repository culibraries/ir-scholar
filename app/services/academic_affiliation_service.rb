# services/degree_grantors_service.rb

module  AcademicAffiliationService
  mattr_accessor :authority
  self.authority = Qa::Authorities::Local.subauthority_for('academic_affiliation')

  def self.select_all_options
    authority.all.map do |element|
      [element[:label], element[:id]]
    end
  end
  def self.oai_publish(id)
    authority.find(id).fetch('oai_publish')
  end
  def self.label(id)
    authority.find(id).fetch('term')
  end
  def self.checkterm(id,term)
    begin
      authority.find(id).fetch(term)
      true
    rescue Exception => e
      false
    end
  end
end
