class BusinessProcessesController < ApplicationController
	before_filter :login_required
	before_filter :iteration_required, :except => [:index, :show]
	helper_method :sort_column, :sort_direction

  def index
#    @business_processes = BusinessProcess.all(:order => sort_column + " " + sort_direction).paginate(:page => params[:page])
    @business_processes = BusinessProcess.paginate(:page => params[:page], :order => sort_column(BusinessProcess) + " " + sort_direction)
    if !current_user.iteration
	    flash[:warning] = "If you want to edit Business Processes you have to pick an iteration."
    end
  end

  def show
    @business_process = BusinessProcess.find(params[:id])
  end

  def new
    @business_process = BusinessProcess.new
  end

  def create
    @business_process = BusinessProcess.new(params[:business_process])
    if @business_process.save
      flash[:notice] = "Successfully created business process."
      redirect_to @business_process
    else
      render :action => 'new'
    end
  end

  def edit
    @business_process = BusinessProcess.find(params[:id])
  end

  def update
    @business_process = BusinessProcess.find(params[:id])
    if @business_process.update_attributes(params[:business_process])
      flash[:notice] = "Successfully updated business process."
      redirect_to @business_process
    else
      render :action => 'edit'
    end
  end

  def destroy
    @business_process = BusinessProcess.find(params[:id])
    @business_process.destroy
    flash[:notice] = "Successfully destroyed business process."
    redirect_to business_processes_url
  end

end
