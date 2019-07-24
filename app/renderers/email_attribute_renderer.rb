# app/renderers/email_attribute_renderer.rb
class EmailAttributeRenderer < Hyrax::Renderers::AttributeRenderer
  def attribute_value_to_html(value)
    %(<span itemprop="email"><a href="mailto:#{value}">#{value}</a></span>)
  end
end
