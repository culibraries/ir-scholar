require 'yaml'

def createAdminSet(name, description)
    if AdminSet.where(title: name.underscore.humanize.titlecase).length == 0 then
        puts "#{name} => #{description}"
        a = AdminSet.new
        a.title = [name.underscore.humanize.titlecase]
        a.description = [description]
        a.save
        Hyrax::AdminSetCreateService.call(admin_set: a, creating_user: User.first!)
        available_workflows = a.permission_template.available_workflows
        mediated_workflow = a.permission_template.available_workflows.where(name: "one_step_mediated_deposit").first
        Sipity::Workflow.activate!(permission_template: a.permission_template, workflow_id: mediated_workflow.id)
    end
end

def runAdminMap()
    YAML.load_file('config/admin_set_map.yml').each do |key,value|
        #puts "#{key} => #{value}"
        createAdminSet(key, value)
    end
end

if __FILE__ == $0
    runAdminMap()
end
