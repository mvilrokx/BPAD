class ManagePrioritiesController < ApplicationController
<<<<<<< HEAD
	def index
#	     @all_paths = Path.all
=======
	before_filter :login_required

	def index
>>>>>>> extract_mpp
	     @all_paths = Path.find :all, :order => 'priority'
	end

	def prioritize_paths
	    puts params

            paths = Path.all
	    paths.each do |path|

	 	puts params['path'].index(path.id.to_s)
	    	path.priority = params['path'].index(path.id.to_s) + 1
<<<<<<< HEAD

                path.save
	    end
	    render :nothing => true
	end
=======
                path.save
	    end
	    render :update do |page|
                page.call 'location.reload'
	    end
	end
	
>>>>>>> extract_mpp
end
