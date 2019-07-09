# Generated via
#  `rails generate hyrax:work DefaultWork`
module Hyrax
  # Generated form for DefaultWork
  class DefaultWorkForm < Hyrax::Forms::WorkForm
    self.model_class = ::DefaultWork
    self.terms += [:resource_type, :contact_email, :contact_phone, :department]
    self.required_fields += [:department, :contact_email]
  end
end
