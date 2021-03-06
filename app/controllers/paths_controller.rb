class PathsController < ApplicationController
  before_filter :find_business_process
	before_filter :login_required
	helper_method :sort_column, :sort_direction


  def index
    #@paths = @business_process.paths.paginate(:page => params[:page], :order => sort_column(Path) + " " + sort_direction)
    @paths = @business_process.paths.order(sort_column(Path) + " " + sort_direction)
    find_cur_path_dev_assgn
  end

  def show
    @path = @business_process.paths.find(params[:id])
  end

  def new
    @path = @business_process.paths.new
#    Show list of value that is either startEvent OR based on previous step
    @available_steps = @business_process.start_element
    find_cur_path_dev_assgn

    @path.steps.build
  end

  def create
    if params[:path][:step_attributes].nil?
        @temppath = params[:path]
	@temppath.delete("steps_attributes")
ap params[:path]

ap @temppath
    end
    @path = @business_process.paths.new(params[:path])
    find_cur_path_dev_assgn
    if @path.save
    	flash[:notice] = "Successfully created path."
#   	redirect_to [@business_process, @path]
    	redirect_to edit_business_process_path_path(@business_process, @path)
    else
    	@path.errors.each_full {|msg| puts msg}
   	render :action => 'new'
    end

  end
  def edit
    @path = @business_process.paths.find(params[:id])
    find_cur_path_dev_assgn
    last_existing_step = @path.last_step
ap @path
ap last_existing_step
puts "printed last existing step"
    if last_existing_step.nil? and 
      @available_steps = @business_process.start_element
      ap @available_steps
      if !@available_steps.blank?
         puts "available_septs is blank"
         step = @path.steps.build
      end
      #@path.steps.build
      ap @step
    else
      last_existing_step.business_process_element.produced_data_objects.each do |element|
        last_existing_step.data_object_instances.find_or_create_by_business_process_element_id(element.id)
      end

      last_existing_step.business_process_element.consumed_data_objects.each do |element|
        ap element
        last_existing_step.data_object_instance_usages.find_or_create_by_business_process_element_id(element.id)
      end

      @available_steps = last_existing_step.business_process_element.next_elements
      if !@available_steps.blank?
         step = @path.steps.build
      end
    end
  end

  def update
    @path = @business_process.paths.find(params[:id])
    find_cur_path_dev_assgn
    if @path.update_attributes(params[:path])
      flash[:notice] = "Successfully updated path."
#      redirect_to [@business_process, @path]
#      render :action => 'edit'
      redirect_to edit_business_process_path_path(@business_process) #, @path)
    else
      render :action => 'edit'
    end
  end

  def copy # copy is to duplicate what new is to create
    @path = @business_process.paths.find(params[:id])
    @paths = @business_process.paths_with_no_steps
  end

  def duplicate  # duplicate is to copy, what create is to new
    if params[:copy_to_path_id].to_i > 0
      @copy_to_path = @business_process.paths.find(params[:copy_to_path_id])
      @copy_to_path.steps = @business_process.paths.find(params[:id]).steps.collect { |c| c.deep_clone }
    else
      @copy_to_path = @business_process.paths.find(params[:id]).deep_clone
    end
    if @copy_to_path.save
      flash[:notice] = "Successfully copied path."
      redirect_to [@business_process, :paths]
    else
    	@path.errors.each_full {|msg| puts msg}
      redirect_to [@business_process, :paths]
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
    find_cur_path_dev_assgn
    if @path_story.backlog_id != @bp_backlog.id
      @path_story.update_attribute(:backlog_id, @bp_backlog.id)
    end
    for bf in @path.build_features
      @bf_story = AfStory.find_from_or_create_in_agilefant(bf, @path_story)
    end
    flash[:notice] = "Agilefant has been updated."
    redirect_to path_steps_path(@business_process.paths.find(params[:id]))
  end


  def find_cur_path_dev_assgn

    var = params[:id]
#   sql = "select u.id, IFNULL ( CONCAT (u.name,  ' ', u.last_Name   ) , CONCAT ('Usre Name: ' , u.username   )) name from users u,  work_assignments w where w.path_id = " + var + " and w.user_id  = u.id "
#   @cur_path_dev_assgn =  @business_process.paths.find_by_sql(sql)

   @cur_path_dev_assgn  = User.find(:all,
                             :select => "u.id, u.username, u.name, u.last_name, w.path_id",
                             :joins => "as u inner join work_assignments as w on w.user_id  = u.id ",
                             :conditions => [" w.path_id = ?"  ,var ])
    if @cur_path_dev_assgn
      @cur_path_dev_assgn.each do | r|
        r.name = r.username + "(" +  (r.name || " .. ") + ")"
      end
    end


  end

  private
    def find_business_process
        @business_process = BusinessProcess.find(params[:business_process_id])
    end



end

