# frozen_string_literal: true

# renders search and external link on show page
class SearchExternalLinkAttributeRenderer < Hyrax::Renderers::AttributeRenderer
  # include ApplicationHelper

  private

  def li_value(value)
    links_to_search_field_and_external_uri(value)
  end

  def links_to_search_field_and_external_uri(query)
    links = []
    unless query.include? '=>nil'
      clean_uri = format_uri(query)
      if hash?(query)
        query_hash = JSON.parse(query.to_s.gsub('=>', ':'))
        label = query_hash['label']
        uri = query_hash['uri']
      elsif query.include?('$')
        label = query.split('$').first
        uri = query.split('$').second
      else
        case options.fetch(:search_field, field).to_s
        when 'rights_statement'
          label = get_value_from_yaml('rights_statements.yml', query)
          uri = search_path(clean_uri)
        when 'degree_grantors'
          label = get_value_from_yaml('degree_grantors.yml', query)
          uri = search_path(clean_uri)
        when 'license'
          label = get_value_from_yaml('licenses.yml', query)
          uri = search_path(clean_uri)
        when 'language'
          label = get_value_from_yaml('language.yml', query)
          uri = facet_search_path(query)
        else
          label = uri
          uri = search_path(clean_uri)
        end
      end
      links << link_to(label, uri) unless label.blank?
      unless uri.blank?
        links << link_to('<span class="glyphicon glyphicon-new-window"></span>'.html_safe, clean_uri,
                         'aria-label' => 'Open link in new window', class: 'btn', target: '_blank')
      end
    end
    links.join('')
  end

  def hash?(s)
    s.include? '=>'
  end

  def facet_search_path(value)
    Rails.application.routes.url_helpers.search_catalog_path("f[#{search_field_sim}][]": value, locale: I18n.locale)
  end

  def search_path(value)
    Rails.application.class.routes.url_helpers.search_catalog_path(search_field: options.fetch(:search_field, field),
                                                                   q: ERB::Util.h(value))
  end

  def search_field_sim
    ERB::Util.h("#{options.fetch(:search_field, field)}_sim")
  end

  def format_uri(s)
    s = Addressable::URI.escape(s) if %w[http https].any? { |p| s.include? p }
    URI.extract(s, %w[http https]).first || ''
  end

  def get_value_from_yaml(file, term)
    yaml = YAML.load_file(File.join(Rails.root, 'config', 'authorities', file))
    value = yaml['terms'].find { |l| l['id'].casecmp(term).zero? }
    return '' if value.nil?

    value['term']
  end

end
