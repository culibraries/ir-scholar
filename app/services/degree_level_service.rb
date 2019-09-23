# services/degree_level_service.rb

module DegreeLevelService
  mattr_accessor :authority
  self.authority = Qa::Authorities::Local.subauthority_for('degree_level')

  def self.select_all_options
    authority.all.map do |element|
      [element[:label], element[:id]]
    end
  end

  def self.label(id)
    authority.find(id).fetch('term')
  end
end
