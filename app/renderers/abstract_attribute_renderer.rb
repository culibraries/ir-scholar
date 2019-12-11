# app/renderers/department_attribute_renderer.rb
# Hyrax::Renderers::AttributeRenderer
# CurationConcerns::Renderers::AttributeRenderer
class AbstractAttributeRenderer < Hyrax::Renderers::AttributeRenderer
  def attribute_value_to_html(value)
    value.html_safe
  end
end
