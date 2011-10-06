# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)
["Business Process Modeler", "Functional Modeler", "Technical Modeler", "Developer", "Administrator"].each do |role|
  Role.find_or_create_by_name role
end

["SAXIAO", "SDEVALLA", "JYOTVENK", "ASIDGIDD", "MIHIPATE", "SOSAGBEM", "HVANGIPU", "SANDDE", "SNANDURI", "DCOHANOF", "GKRISHNA", "KAREREDD", "SUBCHATT", "KARUNART", "JASSINGH"].each do |username|
  developer = User.find_by_username(username)
  developer.roles << Role.find_by_name("Developer")
  developer.save!
end

