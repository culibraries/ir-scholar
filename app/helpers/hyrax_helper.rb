module HyraxHelper
  include ::BlacklightHelper
  include Hyrax::BlacklightOverride
  include Hyrax::HyraxHelperBehavior

  def truncated_summary(options)
    value = options[:value].first
    value= value.strip_tags
    value.truncate_words(50)
  end

  def lookup_term_controlled_vocab(options)
    #new_value=[]
    #byebug
    #options[:value].each do |item|
    LanguageService.label(options)
    #end
    #new_value
  end

end
