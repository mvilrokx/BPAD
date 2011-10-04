class AgilefantController < ApplicationController

  PRODUCT = "HWM"
  RELEASE = "V2.0"

  def plan

    @projects = AfBacklog.all(:include => {:stories => {:children => :tasks}},
                              :conditions => ['backlogs.backlogtype = "Project" and stories.parent_id is null'])

    csv_string = FasterCSV.generate do |csv|

      cols = %w(Outline_Level WBS Name Scheduled_Work Percent_Complete Start_Date Finish_Date Resource_Names Activity Deliverable_Type Product Hyperlink Notes Release_Version)
      csv << cols

      @projects.each do |project|
        csv << [1, "P-#{project.id}", "Project: #{project.name}", nil, nil, nil, nil, nil, nil, nil, PRODUCT, nil, nil, RELEASE]
        project.stories.each do |story|
          csv << [2, "T-#{story.id}", story.name, nil, nil, nil, nil, nil, nil, nil, PRODUCT, nil, nil, RELEASE]
          story.children.each do |sub_story|
            csv << ["3", "T-#{sub_story.id}", sub_story.name, nil, nil, nil, nil, nil, nil, nil, PRODUCT, nil, nil, RELEASE]
            sub_story.tasks.each do |task|
              csv << ["4",
                      "T-#{task.id}",
                      task.name,
                      (task.originalestimate||0)/60,
                      (((((task.originalestimate||0)-(task.effortleft||0)).to_f/(task.originalestimate||1))).to_f)*100,
                      task.story.backlog.startDate.strftime("%m/%d/%Y"),
                      task.story.backlog.endDate.strftime("%m/%d/%Y"),
                      task.developers.join(','),
                      nil,nil,PRODUCT,nil,nil,RELEASE]
            end
          end
        end
      end
    end
    filename = "WFM-Agilefant-Plan-#{Time.now.to_date.to_s}.csv"
    send_data(csv_string, :type => 'text/csv; charset=utf-8; header=present', :filename => filename)

#    render :layout => false
  end
end

