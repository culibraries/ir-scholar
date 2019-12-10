module HyraxHelper
  include ::BlacklightHelper
  include Hyrax::BlacklightOverride
  include Hyrax::HyraxHelperBehavior

  def truncated_summary(options)
    value = options[:value].first
    value= value.strip_tags
    value.truncate_words(50)
  end

end
