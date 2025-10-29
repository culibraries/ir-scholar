# frozen_string_literal: true
module Scholar
  module Ability
    module CollectionAbility
      extend ActiveSupport::Concern
      included do
        def collection_abilities # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
          # models = [::Collection]
          models = [Hyrax::PcdmCollection, Hyrax.config.collection_class].uniq
          if admin?
            models.each do |collection_model|
              can :manage, collection_model
              can :manage_any, collection_model
              can :create_any, collection_model
              can :view_admin_show_any, collection_model
            end
          else
            models.each do |collection_model|
              # can [:edit, :update, :destroy], collection_model do |collection|
              #   test_edit(collection.id)
              # end

              can :deposit, collection_model do |collection|
                Hyrax::Collections::PermissionsService.can_deposit_in_collection?(ability: self, collection_id: collection.id)
              end

              can :view_admin_show, collection_model do |collection|
                # admin show page
                test_read(collection.id)
              end

              can :read, collection_model do |collection|
                # public show page
                test_read(collection.id)
              end
            end
            can :view_admin_show, ::SolrDocument do |solr_doc|
              # admin show page
              Hyrax::Collections::PermissionsService.can_view_admin_show_for_collection?(ability: self, collection_id: solr_doc.id) # checks collections and admin_sets
            end
          end
        end
      end
    end
  end
end
