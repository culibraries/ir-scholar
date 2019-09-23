require 'active_fedora/cleaner'

ActiveFedora::Cleaner.clean!
# PermissionTemplates are tightly coupled to admin sets and collections.  When they are removed using clean!, the
# associated database entries for permission templates also have to be deleted.
Hyrax::PermissionTemplateAccess.destroy_all
Hyrax::PermissionTemplate.destroy_all