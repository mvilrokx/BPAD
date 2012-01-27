class Plan
  attr_accessor :planned_paths

  def initialize(start_date = Date.today.months_since(4).beginning_of_month)

    iteration_start_date = start_date
    assignment_happened = true
    @planned_paths = Hash.new
    business_processes = Hash.new

    paths = Path.joins(:tags).where(:tags => {:name => "1.3m"}).order("priority ASC")

#    BusinessProcess.all.each do |bp|
#      if bp.exists_in_agilefant?
#        business_processes[bp] = AfProjectBucket.first(:conditions => ['proj_id = ?', bp.agilefant_backlog.id]).left_over_hours

#      else
#        puts "#{bp.name} #{bp.id} DOES NOT EXIST IN AGILEFANT"
#      end
#    end

    developers = User.all(:joins => :roles, :conditions => 'roles.name = "Developer"', :order =>:username)

    available_developers = developers.dup

    paths.each do |path|
      if path.business_process.exists_in_agilefant?
        if AfStory.find_from_bpad_object(path) # || business_processes[path.business_process] <= 0
          @planned_paths[path] = [nil, nil]
        else
          timespent = 130 #0
#          if business_processes[path.business_process]  < 130
#            timespent = business_processes[path.business_process]
#          else
#            timespent = 130
#          end

#          business_processes[path.business_process] = business_processes[path.business_process] - 130

          @planned_paths[path] = [iteration_start_date, available_developers.shift, timespent]
          path.update_attribute(:estimated_delivery_date, iteration_start_date)
          if available_developers.empty?
            available_developers = developers.clone
            iteration_start_date = iteration_start_date.next_month
          end
        end
      end
    end
  end


#

#    until paths.empty? or !assignment_happened
#      assignment_happened = false
#      unplanned_paths.each do |path|
#        assign_in_this_iteration = true
#        path.users.each do |user|
#          if !available_users.include?(user)
#            assign_in_this_iteration = false
#          end
#        end

#        if assign_in_this_iteration
#          assignment_happened = true
#          @planned_paths[path] = [iteration_start_date, path.developers.join(',')]
#          path.users.each do |user|
#            available_users.delete(user)
#          end
#        end
#        break if available_users.empty?
#      end
#      unplanned_paths.delete_if {|x| @planned_paths.has_key?(x)}
#      available_users = all_users.dup
#      iteration_start_date = iteration_start_date.next_month
#    end
#  end

  def by_iteration_by_developer(months_ahead = 20)
    developer_use_cases = Array.new
    iteration_use_cases = Array.new # Hash.new
    all_use_cases = Hash.new
    User.all(:joins => :roles, :conditions => 'roles.name = "Developer"', :order =>:username).each do |user|
      ((Date.today.beginning_of_month..Date.today.months_since(months_ahead)).select {|d| d.day ==1}).each do |iteration_start_date|
        @planned_paths.each do |path, path_details|
          if path_details[1] == user && path_details[0] == iteration_start_date
            developer_use_cases << path
          end
        end
        if developer_use_cases.count != 0
          iteration_use_cases << [iteration_start_date, developer_use_cases]
        else
          iteration_use_cases << [iteration_start_date, [Path.new(:name => '')]]
        end
        developer_use_cases = []
      end
      all_use_cases[user] = iteration_use_cases
      iteration_use_cases = []
    end
    all_use_cases
  end

end

