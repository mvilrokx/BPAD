class ManagePrioritiesController < ApplicationController
  before_filter :login_required

	def index
    @all_tags = get_all_tags
#    @all_paths = Path.find :all, :order => 'priority' #, :conditions => "priority IS NOT NULL"
#	  @other_paths = Path.find :all, :conditions => "priority IS NULL"
#    all_tags
     @all_paths = refine_search (params[:filters])
	end

	def prioritize_paths
	  ap params
    for path in Path.all
     	path.priority = params['path'].index(path.id.to_s) + 1
      path.save
    end
    render :nothing => true
	end


	def get_all_tags
     Tag.find :all, :order => 'name'
	end


  def refine_search(filters)
#   filters = params[:filters]
    if filters
      Path.find :all, :order => 'priority' ,
                      :conditions =>  [" id  in (select path_id from taggings t  where t.tag_id  in ( ? ) )" , filters]
    else
      Path.find :all, :order => 'priority' #, :conditions => "priority IS NOT NULL"
    end

  end





end

