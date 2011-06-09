class ManagePrioritiesController < ApplicationController
	def index
#	     @all_paths = Path.all
	     @all_paths = Path.find :all, :order => 'priority'
	end

	def prioritize_paths
	    puts params

            paths = Path.all
	    paths.each do |path|

	 	puts params['path'].index(path.id.to_s)
	    	path.priority = params['path'].index(path.id.to_s) + 1

                path.save
	    end
	    render :nothing => true
	end
end
