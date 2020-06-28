class Ability
  include Scholar::Ability::CollectionAbility
  include Hydra::Ability
  include Hyrax::Ability
  self.ability_logic += [:everyone_can_create_curation_concerns, :collection_abilities]
  self.admin_group_name = 'admin'

  def custom_permissions
    if admin?
      can [:destroy], ActiveFedora::Base
      can [:create, :show, :add_user, :remove_user, :index, :edit, :update, :destroy], Role
      can :manage, Zizia::CsvImport
      can :manage, Zizia::CsvImportDetail
    end
    super
  end

  def admin?
    user_groups.include? admin_group_name
  end
end
