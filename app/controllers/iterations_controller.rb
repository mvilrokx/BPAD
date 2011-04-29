class IterationsController < ApplicationController
	before_filter :login_required
	helper_method :sort_column, :sort_direction

	rescue_from Iteration::InUse, :with => :in_use

	def index
    @iterations = Iteration.paginate(:page => params[:page], :order => sort_column(Iteration) + " " + sort_direction)
  end

  def show
    @iteration = Iteration.find(params[:id])
    @paths = Path.all
    @fams = BusinessArea.roots
  end

  def new
    @iteration = Iteration.new
  end

  def create
    @iteration = Iteration.new(params[:iteration])
    if @iteration.save
      flash[:notice] = "Successfully created iteration."
      redirect_to @iteration
    else
      render :action => 'new'
    end
  end

  def edit
    @iteration = Iteration.find(params[:id])
  end

  def update
    @iteration = Iteration.find(params[:id])
    if @iteration.update_attributes(params[:iteration])
      flash[:notice] = "Successfully updated iteration."
      redirect_to @iteration
    else
      render :action => 'edit'
    end
  end

  def destroy
    @iteration = Iteration.find(params[:id])
    @iteration.destroy
    flash[:notice] = "Successfully destroyed iteration."
    redirect_to iterations_url
  end

  def in_use(exception)
    flash[:error] = "This iteration is in use and therefor cannot be deleted."
    redirect_to iterations_url
  end

end
