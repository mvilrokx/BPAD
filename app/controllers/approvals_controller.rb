class ApprovalsController < ApplicationController
  before_filter :find_bam_to_fam_map
	before_filter :login_required # , :except => [:index, :show]
	helper_method :sort_column, :sort_direction

  def index
    @approvals = @bam_to_fam_map.approvals.all
  end

  def show
    @approval = @bam_to_fam_map.approvals.find(params[:id])
  end

  def new
    @approval = @bam_to_fam_map.approvals.new
  end

  def create
    @approval = @bam_to_fam_map.approvals.new(params[:approval])
    if params[:commit] == "Approve"
    	@approval.approve!
      @bam_to_fam_map.step.map!
    elsif params[:commit] == "Reject"
    	@approval.reject!
   	end
    if @approval.save
      flash[:notice] = "Successfully created approval."
      redirect_to path_steps_path(@bam_to_fam_map.step.path)
    else
      render :action => 'new'
    end
  end

  def edit
    @approval = @bam_to_fam_map.approvals.find(params[:id])
  end

  def update
    @approval = @bam_to_fam_map.approvals.find(params[:id])
    if params[:commit] == "Approve"
    	@approval.approve!
      @bam_to_fam_map.step.map!
    elsif params[:commit] == "Reject"
    	@approval.reject!
      @bam_to_fam_map.step.unmap!
   	end
    redirect_to path_steps_path(@bam_to_fam_map.step.path)

#    @approval = @bam_to_fam_map.approvals.find(params[:id])
#    if @approval.update_attributes(params[:approval])
#      flash[:notice] = "Successfully updated approval."
#      redirect_to path_steps_path(@bam_to_fam_map.step.path)
#    else
#      render :action => 'edit'
#    end
  end

  def destroy
    @approval = @bam_to_fam_map.approvals.find(params[:id])
    @approval.destroy
    flash[:notice] = "Successfully destroyed approval."
    redirect_to path_steps_path(@bam_to_fam_map.step.path)
  end

  private
    def find_bam_to_fam_map
      @bam_to_fam_map = BamToFamMap.find(params[:bam_to_fam_map_id])
    end
end
