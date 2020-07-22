# frozen_string_literal: true
module Scholar
  module Ability
    module CollectionAbility
      extend ActiveSupport::Concern
      included do
        def collection_abilities # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
          if admin?
            can :manage, ::Collection
            can :manage_any, ::Collection
            can :create_any, ::Collection
            can :view_admin_show_any, ::Collection
          end
        end
      end
    end
  end
end