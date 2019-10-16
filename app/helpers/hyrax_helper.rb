module HyraxHelper
  include ::BlacklightHelper
  include Hyrax::BlacklightOverride
  include Hyrax::HyraxHelperBehavior

  def truncated_summary(options)
    value = options[:value].first
    value.truncate_words(50)
  end

end
