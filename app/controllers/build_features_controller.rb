class BuildFeaturesController < ApplicationController
  def index
    @build_features = BuildFeature.all
  end

  def show
    @build_feature = BuildFeature.find(params[:id])
  end

  def new
    @build_feature = BuildFeature.new
  end

  def create
    @build_feature = BuildFeature.new(params[:build_feature])
    if @build_feature.save
      flash[:notice] = "Successfully created build feature."
      redirect_to @build_feature
    else
      render :action => 'new'
    end
  end

  def edit
    @build_feature = BuildFeature.find(params[:id])
  end

  def update
    @build_feature = BuildFeature.find(params[:id])
    if @build_feature.update_attributes(params[:build_feature])
      flash[:notice] = "Successfully updated build feature."
      redirect_to @build_feature
    else
      render :action => 'edit'
    end
  end

  def destroy
    @build_feature = BuildFeature.find(params[:id])
    @build_feature.destroy
    flash[:notice] = "Successfully destroyed build feature."
    redirect_to build_features_url
  end
end