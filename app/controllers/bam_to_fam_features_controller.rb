class BamToFamFeaturesController < ApplicationController
  before_filter :find_step
	before_filter :login_required # , :except => [:index, :show]

  def index
    @bam_to_fam_features = @step.bam_to_fam_features.paginate(:page => params[:page])
  end

  def show
    @bam_to_fam_feature = @step.bam_to_fam_features.find(params[:id])
  end

  def new
    @bam_to_fam_feature = @step.bam_to_fam_features.new
  end

  def create
    if @step.bam_to_fam_map
      @bam_to_fam_map = @step.bam_to_fam_map
    else
      @bam_to_fam_map = @step.create_bam_to_fam_map
    end
    @bam_to_fam_feature = @bam_to_fam_map.bam_to_fam_features.new(:feature_id => params[:feature_id], :step_id => params[:step_id])
    # @bam_to_fam_feature = @step.bam_to_fam_features.new(params[:bam_to_fam_feature])
    if @bam_to_fam_feature.save
      flash[:notice] = "Successfully created bam to fam feature."
      render :partial => "bam_to_fam_maps/available_feature", :locals => { :mapped_feature => @bam_to_fam_feature }
#			render :json => @bam_to_fam_feature.to_json(:include => :feature ), :layout => false
      # redirect_to @bam_to_fam_feature
    else
      render :action => 'new'
    end
  end

  def edit
    @bam_to_fam_feature = @step.bam_to_fam_features.find(params[:id])
  end

  def update
    @bam_to_fam_feature = @step.bam_to_fam_features.find(params[:id])
    if @bam_to_fam_feature.update_attributes(params[:bam_to_fam_feature])
      flash[:notice] = "Successfully updated bam to fam feature."
      redirect_to @bam_to_fam_feature
    else
      render :action => 'edit'
    end
  end

  def destroy
    if params[:id] = -1
      @bam_to_fam_feature = @step.bam_to_fam_features.find_by_feature_id(params[:feature_id])
    else
      @bam_to_fam_feature = @step.bam_to_fam_features.find(params[:id])
    end
    @bam_to_fam_feature.destroy
    
    flash[:notice] = "Successfully destroyed bam to fam feature."
    # redirect_to bam_to_fam_features_url
    render :json => @bam_to_fam_feature, :layout => false
  end

  private
    def find_step
      @step = Step.find(params[:step_id])
    end
end
