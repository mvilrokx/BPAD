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
     	  @interfaces = lba.interfaces
     	  @build_features = lba.build_features
        @mapped_features = @feature.build_features
    	elsif (params[:rel] == 'lbo') then
    	  lbo = Lbo.find(params[:id])
     	  @build_features = lbo.build_features
     	  @logical_entities = lbo.logical_entities
        @mapped_features = @feature.build_features
    	elsif (params[:rel] == 'le') then
    	  le = LogicalEntity.find(params[:id])
     	  @logical_entity_attributes = le.logical_entity_attributes
    	elsif (params[:rel] == 'build_feature') then
    	  bf = BuildFeature.find(params[:id])
     	  @build_features = bf.children
        # @mapped_features = @feature.build_features
      end
    end
    puts "build_features"
    ap @build_features
    puts "mapped_features"
    ap @mapped_features
    
		respond_to do |format|
      format.html  { render :partial => 'lbas/lba_children', 
                            :locals => {:lbas => @lbas, 
                                        :lbos => @lbos,
                                        :bfs => @build_features,
                                  			:mapped_features => @mapped_features,
                                        :les => @logical_entities,
                                        :le_attributes => @logical_entity_attributes,
                                        :interfaces => @interfaces
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
    if params[:id] = -1
      @fam_to_tam_map = @feature.fam_to_tam_maps.find_by_feature_id_and_build_feature_id(params[:feature_id], params[:build_feature_id])
    else
      @fam_to_tam_map = @feature.fam_to_tam_maps.find(params[:id])
    end
#    @fam_to_tam_map = FamToTamMap.find(params[:id])
    @fam_to_tam_map.destroy
    flash[:notice] = "Successfully destroyed fam to tam map."
    render :json => @fam_to_tam_map, :layout => false
#    redirect_to fam_to_tam_maps_url
  end

  private
    def find_feature
      @feature = Feature.find(params[:feature_id]||params[:fam_to_tam_map][:feature_id])
    end


end
