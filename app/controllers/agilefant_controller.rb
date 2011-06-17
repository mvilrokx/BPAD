class AgilefantController < ApplicationController
  def plan
    @projects = AfBacklog.all(:include => {:stories => {:children => :tasks}},
                              :conditions => ['backlogs.backlogtype = "Project" and stories.parent_id is null'])
    render :layout => false
  end
end

