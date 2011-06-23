class StepsController < ApplicationController
  before_filter :find_path
	before_filter :login_required # , :except => [:index, :show]
	helper_method :sort_column, :sort_direction

  def index
    @steps = @path.steps.paginate(:page => params[:page])
  end

  def show
    @step = @path.steps.find(params[:id])
  end

  def new
    @step = @path.steps.new
  end

  def create
    @step = @path.steps.new(params[:step])
    if @step.save
      flash[:notice] = "Successfully created step."
      redirect_to [@path, @step]
    else
      render :action => 'new'
    end
  end

  def edit
    @step = @path.steps.find(params[:id])
  end

  def update
    @step = @path.steps.find(params[:id])
    if @step.update_attributes(params[:step])
      flash[:notice] = "Successfully updated step."
      redirect_to [@path, @step]
    else
      render :action => 'edit'
    end
  end

  def destroy
    @step = @path.steps.find(params[:id])
    @step.destroy
    flash[:notice] = "Successfully destroyed step."
    redirect_to path_steps_url
  end

  private
    def find_path
        @path = Path.find(params[:path_id])
    end

end

