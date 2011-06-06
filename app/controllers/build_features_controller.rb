class BuildFeaturesController < ApplicationController
	before_filter :login_required

  def index
    @build_features = BuildFeature.all
  end

  def show
    @build_feature = BuildFeature.find(params[:id])
    if (request.xhr?)
    	render :partial => 'show_details'
    else
    	render :show
    end
  end

  def new
    @build_feature = BuildFeature.new
  end

  def create
    @build_feature = BuildFeature.new(params[:build_feature])
    if @build_feature.save
      flash[:notice] = "Successfully created build feature."
			render :json => @build_feature, :layout => false
#      redirect_to @build_feature
    else
      render :action => 'new'
    end
  end

  def edit
    @build_feature = BuildFeature.find(params[:id])
    if (request.xhr?)
    	render :partial => 'form', :locals => {:call_type => "ajax"}
    else
    	render :show
    end
  end

  def update
    @build_feature = BuildFeature.find(params[:id])
    if @build_feature.update_attributes(params[:build_feature])
      flash[:notice] = "Successfully updated build feature."
#      redirect_to @build_feature
			render :json => @build_feature, :layout => false
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

