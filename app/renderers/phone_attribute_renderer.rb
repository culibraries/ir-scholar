# app/renderers/phone_attribute_renderer.rb
class PhoneAttributeRenderer < CurationConcerns::Renderers::AttributeRenderer
  def attribute_value_to_html(value)
    %(<span itemprop="telephone"><a href="tel:#{value}">#{value}</a></span>)
  end
end
