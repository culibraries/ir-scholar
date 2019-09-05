# Generated via
#  `rails generate hyrax:work DefaultWork`
module Hyrax
  class DefaultWorkPresenter < Hyrax::WorkShowPresenter
    delegate :contact_email, :contact_phone, :department, to: :solr_document
  end
end