class ManagePrioritiesController < ApplicationController
	before_filter :login_required

	def index
    @all_paths = Path.find :all, :order => 'priority' #, :conditions => "priority IS NOT NULL"
#	  @other_paths = Path.find :all, :conditions => "priority IS NULL"
	end

	def prioritize_paths
    for path in Path.all
     	path.priority = params['path'].index(path.id.to_s) + 1
      path.save
    end
    render :nothing => true
	end
end

