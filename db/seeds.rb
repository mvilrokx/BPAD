# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

use_cases_file = "db/useCasesFile2.csv"
developers = []
open(use_cases_file) do |use_cases|
  puts "\nLoading Use Cases from file " + use_cases_file
  use_cases.read.each_line do |use_case|
    if !use_case.blank?
      business_process_name, name, description, developer_names = use_case.chomp.strip.split("|")
      assigned_developers = developer_names.chomp.strip.split("#")
      assigned_developers.each do |username|
        if user = User.first(:conditions => ["username = (?)", username])
          developers << user
        else
          puts "Warning: #{username} was not found in BPAD as a User."
        end
      end
      bp = BusinessProcess.find_by_name(business_process_name)
      if bp
        path = Path.find_or_initialize_by_name(:name => name, :description => description, :business_process => bp)
        path.users = developers
        path.do_not_track = true
        path.save!
        print "."
      else
        puts "Skipped loading of " + use_case + " because the Business Process it is attached to ('" + business_process_name + "') does not exist."

      end
    end
  end
  puts "\nDone!"
end

