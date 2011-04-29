class FunctionalWorkUnitsController < ApplicationController
	before_filter :login_required

  def index
    @functional_work_units = FunctionalWorkUnit.all
  end

  def show
    @functional_work_unit = FunctionalWorkUnit.find(params[:id])
    if (request.xhr?)
    	render :partial => 'show_details'
    else
    	render :show
    end
  end

  def new
    @functional_work_unit = FunctionalWorkUnit.new
  end

  def create
    @functional_work_unit = FunctionalWorkUnit.new(params[:functional_work_unit])
    if @functional_work_unit.save
      flash[:notice] = "Successfully created functional work unit."
#      redirect_to @functional_work_unit
			render :json => @functional_work_unit, :layout => false
    else
      render :action => 'new'
    end
  end

  def edit
    @functional_work_unit = FunctionalWorkUnit.find(params[:id])
  end

  def update
    @functional_work_unit = FunctionalWorkUnit.find(params[:id])
    if @functional_work_unit.update_attributes(params[:functional_work_unit])
      flash[:notice] = "Successfully updated functional work unit."
#      redirect_to @functional_work_unit
			render :json => @functional_work_unit, :layout => false
    else
      render :action => 'edit'
    end
  end

  def destroy
    @functional_work_unit = FunctionalWorkUnit.find(params[:id])
    @functional_work_unit.destroy
    flash[:notice] = "Successfully destroyed functional work unit."
    redirect_to functional_work_units_url
  end

  def features
    if !params[:id].blank?
      @features = FunctionalWorkUnit.find(params[:id]).features.all
    else
      @features = Feature.all
    end
    render :layout => false
  end

end
