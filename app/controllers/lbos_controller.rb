class LbosController < ApplicationController
	before_filter :login_required

  def index
    @lbos = Lbo.all
  end

  def show
    @lbo = Lbo.find(params[:id])
    if (request.xhr?)
    	render :partial => 'show_details'
    else
    	render :show
    end
  end

#  def new
#    @lbo = Lbo.new
#    render :nothing => true
#  end

  def create
    @lbo = Lbo.new(params[:lbo])
    @lbo.business_area_id = nil if @lbo.business_area_id == 0 # THIS SHOULD NEVER HAPPEN
    if @lbo.save
      flash[:notice] = "Successfully created lbo."
			render :json => @lbo, :layout => false
		else
	    render :action => 'new'
    end
#    render :nothing => true
  end

  def edit
    @lbo = Lbo.find(params[:id])
    render :nothing => true
  end

  def update
    @lbo = Lbo.find(params[:id])
    if @lbo.update_attributes(params[:lbo])
      flash[:notice] = "Successfully updated lbo."
			render :json => @lbo, :layout => false
#      redirect_to @lbo
    else
      render :action => 'edit'
    end
#    render :nothing => true
  end

  def destroy
    @lbo = Lbo.find(params[:id])
    @lbo.destroy
    flash[:notice] = "Successfully destroyed lbo."
#    redirect_to lbos_url
		render :nothing => true
  end
end
