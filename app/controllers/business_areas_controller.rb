class BusinessAreasController < ApplicationController
	before_filter :login_required
	helper_method :sort_column, :sort_direction

  def index
  	if (params[:id]) then
  	  @business_areas = BusinessArea.find(params[:id]).children.paginate(:page => params[:page], :order => sort_column(BusinessArea) + " " + sort_direction)
    else
	    @business_areas = BusinessArea.roots.paginate(:page => params[:page], :order => sort_column(BusinessArea) + " " + sort_direction)
ap @business_areas
    end
		respond_to do |format|
      format.html # index.html.erb
      format.json  { render :json => @business_areas}
    end
  end

  def lba_children
  	if (params[:id] == 'root') then
	    @business_areas = BusinessArea.roots
    else
    	if (params[:rel] == 'lba') then
    		lba = BusinessArea.find(params[:id])
    	  @business_areas = lba.children
    	  @business_objects = lba.Lbos
    	  @functional_work_units = lba.FunctionalWorkUnits
    	elsif (params[:rel] == 'fwu') then
    		fwu = FunctionalWorkUnit.find(params[:id])
    		@features = fwu.features
      end
    end
		respond_to do |format|
      format.html  { render :partial => 'lba_children', :locals => {:lbas => @business_areas,
      																															:lbos => @business_objects,
      																															:functional_work_units => @functional_work_units,
      																															:features => @features
      																															}}
      format.json  { render :json => @business_areas}
    end
  end

  def show
    @business_area = BusinessArea.find(params[:id])
    if (request.xhr?)
    	render :partial => 'show_details'
    else
    	render :show
    end
  end

#  def new
#    @business_area = BusinessArea.new
#  end

  def create
    params[:business_area][:parent_id] = nil if params[:business_area][:parent_id] == "root"
    @business_area = BusinessArea.new(params[:business_area])
#    @business_area.parent_id = nil if params[:business_area][:parent_id] == "root"
    if @business_area.save
      flash[:notice] = "Successfully created business area."
p @business_area
			render :json => @business_area, :layout => false
#     redirect_to @business_area
    else
      render :action => 'new'
    end
#   	render :nothing => true
  end

  def edit
    @business_area = BusinessArea.find(params[:id])
  end

  def update
    params[:business_area][:parent_id] = nil if params[:business_area][:parent_id] == "root"
    @business_area = BusinessArea.find(params[:id])
    if @business_area.update_attributes(params[:business_area])
      flash[:notice] = "Successfully updated business area."
#      redirect_to @business_area
			render :json => @business_area, :layout => false
    else
      render :action => 'edit'
    end
#   	render :nothing => true
  end

  def destroy
    @business_area = BusinessArea.find(params[:id])
    @business_area.destroy
    flash[:notice] = "Successfully destroyed business area."
    redirect_to business_areas_url
  end
end
