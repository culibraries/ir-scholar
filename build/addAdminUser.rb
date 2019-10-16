admin = Role.where(name: "admin").first_or_create 
admin.users << User.find_by_user_key(ARGV[0])
admin.save