class AgilefantController < ApplicationController
  def plan
    @project_backlog = AfBacklog.find(:conditions => ['backlogtype = Project'])
    @projects = AfBacklog.all(:include => {:stories => {:children => :tasks}}, :conditions => ['backlogs.backlogtype = "Project" and stories.parent_id is null'])
  end

end

