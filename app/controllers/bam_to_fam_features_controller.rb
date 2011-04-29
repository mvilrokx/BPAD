class BamToFamFeaturesController < ApplicationController
  before_filter :find_step
	before_filter :login_required # , :except => [:index, :show]

  def index
    @bam_to_fam_features = @step.bam_to_fam_features.all
  end

  def show
    @bam_to_fam_feature = @step.bam_to_fam_features.find(params[:id])
  end

  def new
    @bam_to_fam_feature = @step.bam_to_fam_features.new
  end

  def create
    @bam_to_fam_feature = @step.bam_to_fam_features.new(params[:bam_to_fam_feature])
    if @bam_to_fam_feature.save
      flash[:notice] = "Successfully created bam to fam feature."
      redirect_to @bam_to_fam_feature
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
    @bam_to_fam_feature = @step.bam_to_fam_features.find(params[:id])
    @bam_to_fam_feature.destroy
    flash[:notice] = "Successfully destroyed bam to fam feature."
    redirect_to bam_to_fam_features_url
  end

  private
    def find_step
      @step = Step.find(params[:step_id])
    end
end
