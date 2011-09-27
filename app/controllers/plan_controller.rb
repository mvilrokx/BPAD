class PlanController < ApplicationController
  def bpad
    @projects = BusinessProcess.all(:include => :paths)

    @paths = Path.all(:joins => :users, :group => "id", :order => "priority")
    available_users = User.all
    planned_path = Hash.new
    already_planned_paths = []

    iteration_start_date = Date.today.months_since(4).beginning_of_month
    assignment_happened = true

    until @paths.empty? or !assignment_happened
      assignment_happened = false
      @paths.each do |path|
        assign_in_this_iteration = true
        path.users.each do |user|
          if !available_users.include?(user)
            assign_in_this_iteration = false
          end
        end
        if assign_in_this_iteration
          assignment_happened = true
          planned_path[path] = [iteration_start_date, path.developers.join(',')]
          puts "For path #{path.name} ... "
          path.users.each do |user|
            #delete developer from list
            puts "Deleting #{user.username}"
            available_users.delete(user)
          end
          already_planned_paths << path
        end
        # exit when developers used
        puts "No More Developers Available" if available_users.empty?
        break if available_users.empty?

      end
      ### reset
      # remove already planned paths from list
      @paths.delete_if {|x| already_planned_paths.include?(x)}
      available_users = User.all
      iteration_start_date = iteration_start_date.next_month
    end
    csv_string = FasterCSV.generate do |csv|

      cols = %w(Outline_Level WBS Name Scheduled_Work Percent_Complete Start_Date Finish_Date Resource_Names Activity Deliverable_Type Product Hyperlink Notes Release_Version)
      csv << cols


      @projects.each do |project|
        csv << [1, "P-#{project.id}", project.name, nil, nil, nil, nil, nil, nil, nil, "HXT", nil, nil, "V1.3"]
        project.paths.each do |path|
          story = AfStory.find_from_bpad_object(path)
          if story
            csv << [2, "T-#{story.id}", story.name, nil, nil, nil, nil, nil, nil, nil, "HXT", nil, nil, "V1.3"]
            story.children.each do |sub_story|
              csv << ["3", "T-#{sub_story.id}", sub_story.name, nil, nil, nil, nil, nil, nil, nil, "HXT", nil, nil, "V1.3"]
              sub_story.tasks.each do |task|
                csv << ["4",
                        "T-#{task.id}",
                        task.name,
                        (task.originalestimate||0)/60,
                        (((((task.originalestimate||0)-(task.effortleft||0)).to_f/(task.originalestimate||1))).to_f)*100,
                        task.story.backlog.startDate.strftime("%m/%d/%Y"),
                        task.story.backlog.endDate.strftime("%m/%d/%Y"),
                        task.developers.join(','),
                        nil,nil,"HXT",nil,nil,"V1.3"]
              end
            end
          else
            if planned_path[path]
              csv << [2, "T-#{path.id}", path.name, path.estimate||130*path.developers.count, nil, planned_path[path][0].strftime("%m/%d/%Y"), planned_path[path][0].end_of_month.strftime("%m/%d/%Y"), planned_path[path][1], nil, nil, "HXT", nil, nil, "V1.3"]
            else # unplanned
              csv << [2, "T-#{path.id}", path.name, nil, nil, nil, nil, nil, nil, nil, "HXT", nil, nil, "V1.3"]
            end
          end
        end
      end
    end
    filename = "WFM-BPAD-Plan-#{Time.now.to_date.to_s}.csv"
    send_data(csv_string, :type => 'text/csv; charset=utf-8; header=present', :filename => filename)
  end
end

