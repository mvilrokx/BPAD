class PlansController < ApplicationController
	helper_method :sort_column, :sort_direction

  def use_case_planning
    plan = Plan.new
    @use_case_plan = plan.by_iteration_by_developer
  end

  def product_managers_todo_list
    @planned_paths = Plan.new.planned_paths
		from = Date.new 2011, 5
		to = Date.new 2013, 1
		@months = Array.new
		m = from
		while m <= to
			@months << m
			m >>= 1
		end
  end

  def bpad
    application = "HXT"
    release = "V1.3"
    max_project_length = 200

    @projects = BusinessProcess.all(:include => :paths)

    available_users = User.all
    planned_path = Plan.new.planned_paths

    csv_string = FasterCSV.generate do |csv|

      cols = %w(Outline_Level WBS Name Scheduled_Work Percent_Complete Start_Date Finish_Date Resource_Names Activity Deliverable_Type Product Hyperlink Notes Release_Version)
      csv << cols
      csv << [1, "P-1", "WFM Development Plan", nil, nil, nil, nil, nil, nil, nil, application, nil, nil, release]
      @projects.each do |project|
        if project.exists_in_agilefant?
          csv << [2, "P-#{project.id}", ("Project: #{project.name}")[0..max_project_length], nil, nil, nil, nil, nil, nil, nil, application, nil, nil, release]
          AfBacklog.find_from_business_process(project).stories.each do |story|
            if story
              csv << [3, "T-#{story.id}", (story.name)[0..max_project_length], nil, nil, nil, nil, nil, nil, nil, application, nil, nil, release]
              story.children.each do |sub_story|
                csv << ["4", "T-#{sub_story.id}", (sub_story.name)[0..max_project_length], nil, nil, nil, nil, nil, nil, nil, application, nil, nil, release]
                sub_story.tasks.each do |task|
                  csv << ["5",
                          "T-#{task.id}",
                          (task.name)[0..max_project_length],
                          (task.originalestimate||0)/60,
                          (((((task.originalestimate||0)-(task.effortleft||0)).to_f/(task.originalestimate||1))).to_f)*100,
                          task.story.backlog.startDate.strftime("%m/%d/%Y"),
                          task.story.backlog.endDate.strftime("%m/%d/%Y"),
                          task.developers.join(','),
                          nil,nil,application,nil,nil,release]
                end
              end
            end
          end


          project.paths.each do |path|
            story = AfStory.find_from_bpad_object(path)
            if !story
  #            csv << [3, "T-#{story.id}", story.name, nil, nil, nil, nil, nil, nil, nil, application, nil, nil, release]
  #            story.children.each do |sub_story|
  #              csv << ["4", "T-#{sub_story.id}", sub_story.name, nil, nil, nil, nil, nil, nil, nil, application, nil, nil, release]
  #              sub_story.tasks.each do |task|
  #                csv << ["5",
  #                        "T-#{task.id}",
  #                        task.name,
  #                        (task.originalestimate||0)/60,
  #                        (((((task.originalestimate||0)-(task.effortleft||0)).to_f/(task.originalestimate||1))).to_f)*100,
  #                        task.story.backlog.startDate.strftime("%m/%d/%Y"),
  #                        task.story.backlog.endDate.strftime("%m/%d/%Y"),
  #                        task.developers.join(','),
  #                        nil,nil,application,nil,nil,release]
  #              end
  #            end
  #          else
              if planned_path[path] &&  planned_path[path][0] && planned_path[path][2]
                csv << [3, "T-#{path.id}", (path.name)[0..max_project_length], path.estimate||planned_path[path][2]||130*path.developers.count, nil, planned_path[path][0].strftime("%m/%d/%Y"), planned_path[path][0].end_of_month.strftime("%m/%d/%Y"), planned_path[path][1].username, nil, nil, application, nil, nil, release]
#              else # unplanned
#                csv << [3, "T-#{path.id}", path.name, nil, nil, nil, nil, nil, nil, nil, application, nil, nil, release]
              end
            end
          end
        end
      end

# PM PLAN
      csv << [1, "P-1", "WFM Product Management Plan", nil, nil, nil, nil, nil, nil, nil, application, nil, nil, release]
      pm_product_backlog = AfBacklog.first(:conditions => "name = 'Fusion WFM Functional'")
      pm_product_backlog.children.each do |project_backlog|
        csv << [2, "P-#{project_backlog.id}", ("Project: #{project_backlog.name}")[0..max_project_length], nil, nil, nil, nil, nil, nil, nil, application, nil, nil, release]
        project_backlog.stories.each do |story|
          if story
            csv << [3, "T-#{story.id}", (story.name)[0..max_project_length], nil, nil, nil, nil, nil, nil, nil, application, nil, nil, release]
            story.children.each do |sub_story|
              csv << ["4", "T-#{sub_story.id}", (sub_story.name)[0..max_project_length], nil, nil, nil, nil, nil, nil, nil, application, nil, nil, release]
              sub_story.tasks.each do |task|
                csv << ["5",
                        "T-#{task.id}",
                        (task.name)[0..max_project_length],
                        (task.originalestimate||0)/60,
                        (((((task.originalestimate||0)-(task.effortleft||0)).to_f/(task.originalestimate||1))).to_f)*100,
                        task.story.backlog.startDate.strftime("%m/%d/%Y"),
                        task.story.backlog.endDate.strftime("%m/%d/%Y"),
                        task.developers.join(','),
                        nil,nil,application,nil,nil,release]
              end
            end
          end
        end
      end

    end
    filename = "WFM-BPAD-Plan-#{Time.now.to_date.to_s}.csv"
    send_data(csv_string, :type => 'text/csv; charset=utf-8; header=present', :filename => filename)
  end
end

