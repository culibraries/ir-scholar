# frozen_string_literal: true


    # renders search and external link on show page
class SearchExternalLinkAttributeRenderer < Hyrax::Renderers::AttributeRenderer
  #include ApplicationHelper
  #private

  def li_value(value)
    links_to_search_field_and_external_uri(search_field, value)
  end

  def search_field
    options.fetch(:search_field, field)
  end

  def links_to_search_field_and_external_uri(field, query)
    links = []
    unless query.include? '=>nil'
      if hash?(query)
        query_hash = JSON.parse(query.to_s.gsub('=>', ':'))
        label = query_hash['label']
        uri = query_hash['uri']
      elsif query.include?('$')
        label = query.split('$').first
        uri = query.split('$').second
      else
        # label = query
        label = case field
          when 'rights_statement' then get_value_from_yaml('rights_statements.yml',query)
          when 'language' then get_value_from_yaml('language.yml',query)
          when 'degree_grantors' then get_value_from_yaml('degree_grantors.yml', query)
          when 'license' then get_value_from_yaml('licenses.yml', query)

          else query
        end
        uri = maybe_uri(query)
      end
      links << link_to(label, search_path_for(uri)) unless label.blank?
      links << link_to('<span class="glyphicon glyphicon-new-window"></span>'.html_safe, uri, 'aria-label' => 'Open link in new window', class: 'btn', target: '_blank') unless uri.blank?
    end

    links.join('')
  end

  def search_path_for(s)
    Rails.application.class.routes.url_helpers.search_catalog_path(search_field: search_field, q: ERB::Util.h(s))
  end

  def hash?(s)
    s.include? '=>'
  end

  def maybe_uri(s)
    s = Addressable::URI.escape(s) if %w[http https].any? { |p| s.include? p }
    URI.extract(s, %w[http https]).first || ''
  end

  def maybe_license_uri(term)
    extract_value_from_yaml(YAML.load_file(File.join(Rails.root, 'config', 'authorities', 'licenses.yml')), term)
  end

  def maybe_rights_statement_uri(term)
    extract_value_from_yaml(YAML.load_file(File.join(Rails.root, 'config', 'authorities', 'rights_statements.yml')), term)
  end

  def extract_value_from_yaml(yaml, term)
    value = yaml['terms'].find { |l| l['term'].casecmp(term).zero? }
    return '' if value.nil?

    value['id']
  end

  def get_value_from_yaml(file, term)
    yaml = YAML.load_file(File.join(Rails.root, 'config', 'authorities', file))
    value = yaml['terms'].find { |l| l['id'].casecmp(term).zero? }
    return '' if value.nil?
    value['term']
  end

end
