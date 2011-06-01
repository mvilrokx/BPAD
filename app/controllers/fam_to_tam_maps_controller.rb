class FamToTamMapsController < ApplicationController
  before_filter :find_feature
	before_filter :login_required # , :except => [:index, :show]

  def lba_children
  	if (params[:id] == 'root') then
      @lbas = Lba.roots
    else
    	if (params[:rel] == 'lba') then
    	  lba = Lba.find(params[:id])
     	  @lbas = lba.children
     	  @lbos = lba.lbos
     	  @build_features = lba.build_features
    	elsif (params[:rel] == 'lbo') then
    	  lbo = Lbo.find(params[:id])
     	  @build_features = lbo.build_features
    	elsif (params[:rel] == 'build_feature') then
    	  bf = BuildFeature.find(params[:id])
     	  @build_features = bf.children
        @mapped_features = @feature.build_features
      end
    end
		respond_to do |format|
      format.html  { render :partial => 'lbas/lba_children', 
                            :locals => {:lbas => @lbas, 
                                        :lbos => @lbos,
                                        :bfs => @build_features,
                                  			:mapped_features => @mapped_features
      																	}}
    end
  end
  
  def index
    @fam_to_tam_maps = @feature.fam_to_tam_maps.all
    @build_features = BuildFeature.all
  end

  def show
    @fam_to_tam_map = FamToTamMap.find(params[:id])
  end

  def new
    @fam_to_tam_map = FamToTamMap.new
  end

  def create
    @fam_to_tam_map = @feature.fam_to_tam_maps.new(params[:fam_to_tam_map])
#    @fam_to_tam_map = FamToTamMap.new(params[:fam_to_tam_map])
    if @fam_to_tam_map.save
      flash[:notice] = "Successfully created fam to tam map."
      render :partial => "fam_to_tam_maps/mapped_feature", :locals => { :mapped_feature => @fam_to_tam_map }
#      redirect_to @fam_to_tam_map
    else
      render :action => 'new'
    end
  end

  def edit
    @fam_to_tam_map = FamToTamMap.find(params[:id])
  end

  def update
    @fam_to_tam_map = FamToTamMap.find(params[:id])
    if @fam_to_tam_map.update_attributes(params[:fam_to_tam_map])
      flash[:notice] = "Successfully updated fam to tam map."
      redirect_to @fam_to_tam_map
    else
      render :action => 'edit'
    end
  end

  def destroy
    @fam_to_tam_map = FamToTamMap.find(params[:id])
    @fam_to_tam_map.destroy
    flash[:notice] = "Successfully destroyed fam to tam map."
    redirect_to fam_to_tam_maps_url
  end

  private
    def find_feature
      @feature = Feature.find(params[:feature_id]||params[:fam_to_tam_map][:feature_id])
    end


end
