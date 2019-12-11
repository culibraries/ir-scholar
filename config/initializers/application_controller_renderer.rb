# Be sure to restart your server when you modify this file.

# ActiveSupport::Reloader.to_prepare do
#   ApplicationController.renderer.defaults.merge!(
#     http_host: 'example.org',
#     https: false
#   )
# end
class String
    def strip_tags
      ActionController::Base.helpers.strip_tags(self)
    end
  end
Hyrax::Renderers::LicenseAttributeRenderer.class_eval do
  def get_value_from_yaml(term)
    yaml = YAML.load_file(File.join(Rails.root, 'config', 'authorities', 'licenses.yaml'))
    value = yaml['terms'].find { |l| l['id'].casecmp(term).zero? }
    return '' if value.nil?
    value['term']
  end

  def attribute_value_to_html(value)
    begin
      parsed_uri = URI.parse(value)
    rescue URI::InvalidURIError
      nil
    end
    if parsed_uri.nil?
      ERB::Util.h(value)
    else
      url="/catalog?q=#{ERB::Util.h(value)}&search_field=license"
      %(<a href=#{url} target="_blank">#{Hyrax.config.license_service_class.new.label(value)}</a><a aria-label="Open link in new window" class="btn" target="_blank" href=#{ERB::Util.h(value)} ><span class="glyphicon glyphicon-new-window"></span></a>)
     # link_to('<span class="glyphicon glyphicon-new-window"></span>'.html_safe, parsed_uri, 'aria-label' => 'Open link in new window', class: 'btn', target: '_blank')
    end
    
  end
end