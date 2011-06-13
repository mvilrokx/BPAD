class PathsController < ApplicationController
  before_filter :find_business_process
	before_filter :login_required
	helper_method :sort_column, :sort_direction

  def index
    @paths = @business_process.paths.paginate(:page => params[:page], :order => sort_column(Path) + " " + sort_direction)
  end

  def show
    @path = @business_process.paths.find(params[:id])
  end

  def new
    @path = @business_process.paths.new
#    Show list of value that is either startEvent OR based on previous step
    @available_steps = @business_process.business_process_elements.all(:conditions => "element_type = 'startEvent'")

    @path.steps.build
  end

  def create
    @path = @business_process.paths.new(params[:path])
    if @path.save
      flash[:notice] = "Successfully created path."
#      redirect_to [@business_process, @path]
      redirect_to edit_business_process_path_path(@business_process, @path)
    else
    	@path.errors.each_full {|msg| puts msg}
      render :action => 'new'
    end
  end

  def edit
    @path = @business_process.paths.find(params[:id])
    last_existing_step = Step.find_by_id(@path.steps.maximum("id"))
    if last_existing_step.nil?
      @available_steps = @business_process.business_process_elements.all(:conditions => "element_type = 'startEvent'")
      @path.steps.build
    else
      @available_steps = last_existing_step.business_process_element.target_elements
      if !@available_steps.blank?
         @path.steps.build
      end
    end
  end

  def duplicate
    @path = @business_process.paths.find(params[:id]).deep_clone
    @path.priority ||= 5.to_s
    if @path.save
      flash[:notice] = "Successfully duplicated path."
      redirect_to business_process_paths_path(@business_process)
    else
    	@path.errors.each_full {|msg| puts msg}
      render :action => 'new'
    end
  end

  def update
    @path = @business_process.paths.find(params[:id])
    if @path.update_attributes(params[:path])
      flash[:notice] = "Successfully updated path."
#      redirect_to [@business_process, @path]
#      render :action => 'edit'
      redirect_to edit_business_process_path_path(@business_process, @path)
    else
      render :action => 'edit'
    end
  end

  def destroy
    @path = @business_process.paths.find(params[:id])
    @path.destroy
    flash[:notice] = "Successfully destroyed path."
    redirect_to business_process_paths_url
  end

  def inform_functional_approvers
    @path = @business_process.paths.find(params[:id])
    for approver in Path.find(params[:id]).non_approvers
      UserMailer.deliver_approval_email(approver, current_user, @business_process, @path)
    end
    flash[:notice] = "Emails were send."
    redirect_to path_steps_path(@business_process.paths.find(params[:id]))
  end

  def send_to_agilefant
    @path = @business_process.paths.find(params[:id])
    @bp_backlog = AfBacklog.find_from_or_create_in_agilefant(@business_process)
    @path_story = AfStory.find_from_or_create_in_agilefant(@path)
    if @path_story.backlog_id != @bp_backlog.id
      @path_story.update_attribute(:backlog_id, @bp_backlog.id)
    end
    for bf in @path.build_features
      @bf_story = @path_story.children.new
      @bf_story.initialize_from_bpad(bf)
      @bf_story.save!
    end
    flash[:notice] = "Agilefant has been updated."
    redirect_to path_steps_path(@business_process.paths.find(params[:id]))
  end

  private
    def find_business_process
        @business_process = BusinessProcess.find(params[:business_process_id])
    end

end

