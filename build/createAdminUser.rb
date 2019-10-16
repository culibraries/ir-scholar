# Variable Please change within Prod system
# If in prod change to Identikey email and display_name
# Password set random not used when using SAML 
email = "admin@colorado.edu"
password = "password1915"
display_name ="Admin"

#create Admin Role
admin = Role.create(name: "admin")
#create user
User.where(email: email).first_or_create do |user|
    user.email = email
    user.display_name = display_name
    user.password = password
end
#assign user to admin role
admin.users << User.find_by_user_key(email)
admin.save
data= ContentBlock.where(name:"header_background_color").first_or_create do |colors|
    colors.name ="header_background_color"
    colors.value = "#000000"
end
data.save
data= ContentBlock.where(name:"header_text_color").first_or_create do |colors|
    colors.name ="header_text_color"
    colors.value = "#FFFFFF"
end
data.save
data=ContentBlock.where(name:"link_color").first_or_create do |colors|
    colors.name ="link_color"
    colors.value = "#2e74b2"
    colors.save
end
data.save
data=ContentBlock.where(name:"footer_link_color").first_or_create do |colors|
    colors.name ="footer_link_color"
    colors.value = "#cfb87c"
    colors.save
end
data.save
data=ContentBlock.where(name:"primary_button_background_color").first_or_create do |colors|
    colors.name ="primary_button_background_color"
    colors.value = "#286090"
    colors.save
end
data.save
