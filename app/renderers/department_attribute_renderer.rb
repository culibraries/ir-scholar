# app/renderers/department_attribute_renderer.rb
# Hyrax::Renderers::AttributeRenderer
# CurationConcerns::Renderers::AttributeRenderer
class DepartmentAttributeRenderer < CurationConcerns::Renderers::AttributeRenderer
  def attribute_value_to_html(value)
    %(<span itemprop="department">#{::DepartmentsService.label(value)}</span>)
  end
end
