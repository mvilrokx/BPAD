class BamToFamMapsController < ApplicationController
  before_filter :find_step
	before_filter :login_required # , :except => [:index, :show]
	helper_method :sort_column, :sort_direction

  def index
    @bam_to_fam_maps = @step.bam_to_fam_map
  end

  def show
    if @step.bam_to_fam_map
      @bam_to_fam_map = @step.bam_to_fam_map
      @mapped_features = @bam_to_fam_map.bam_to_fam_features
    else
      @bam_to_fam_map = @step.build_bam_to_fam_map
      @mapped_features = []
    end
    render :layout => 'tree_with_two_columns'
  end

  def new
    if @step.bam_to_fam_map
      @bam_to_fam_map = @step.bam_to_fam_map
    else
      @bam_to_fam_map = @step.build_bam_to_fam_map
    end
    @features = Feature.all
    @fwus = FunctionalWorkUnit.all
    @mapped_features = []
  end

  def create
		if params[:bam_to_fam_features_attributes]
	    @bam_to_fam_map = @step.build_bam_to_fam_map(params[:bam_to_fam_map])
			# Manually create the mapped features from the multi select toggle box
      params[:bam_to_fam_features_attributes][:feature_id].each do |map_feature|
      	@bam_to_fam_map.bam_to_fam_features_attributes = [{:feature_id => map_feature, :step_id => @step.id}]
      end

      if @bam_to_fam_map.save
        flash[:notice] = "Successfully created bam to fam map."
        redirect_to path_steps_path(@step.path)
      else
        render :action => 'new'
      end
    else
      redirect_to path_steps_path(@step.path)
    end
  end

  def edit
    @bam_to_fam_map = @step.bam_to_fam_map
#    @mapped_features = @step.features
    @mapped_features = @bam_to_fam_map.bam_to_fam_features
#    @features = Feature.all - @mapped_features
    @fwus = FunctionalWorkUnit.all
  end

  def update
		if params[:bam_to_fam_features_attributes]
      @bam_to_fam_map = @step.bam_to_fam_map
  		# Add features
      params[:bam_to_fam_features_attributes][:feature_id].each do |map_feature|
  	    if !@bam_to_fam_map.bam_to_fam_features.find_by_feature_id_and_step_id(map_feature, @step.id)
  	    	@bam_to_fam_map.bam_to_fam_features_attributes = [{:feature_id => map_feature, :step_id => @step.id}]
  	    end
      end

  		# Remove features
      @bam_to_fam_map.bam_to_fam_features.all.each do |mapped_feature|
      	if !params[:bam_to_fam_features_attributes][:feature_id].include?(mapped_feature.feature_id.to_s)
      		ap params[:bam_to_fam_features_attributes][:feature_id]
      		puts "not found"
      		puts mapped_feature.feature_id
      		# DELETE
  	    	@bam_to_fam_map.bam_to_fam_features_attributes = [{:id => mapped_feature.id, '_destroy' => '1'}]
     		end
      end

      if @bam_to_fam_map.update_attributes(params[:bam_to_fam_map])
        flash[:notice] = "Successfully updated bam to fam map."
        redirect_to path_steps_path(@step.path)
      else
        render :action => 'edit'
      end
    else
      destroy
    end
  end

  def destroy
    @bam_to_fam_map = @step.bam_to_fam_map
    @bam_to_fam_map.destroy
    flash[:notice] = "Successfully destroyed bam to fam map."
    redirect_to path_steps_path(@step.path)
  end

  def lba_children
  	if (params[:id] == 'root') then
	    @business_areas = BusinessArea.roots
    else
    	if (params[:rel] == 'lba') then
    		lba = BusinessArea.find(params[:id])
    	  @business_areas = lba.children
    	  @business_objects = lba.Lbos
    	  @functional_work_units = lba.FunctionalWorkUnits
    	elsif (params[:rel] == 'fwu') then
    		@features = FunctionalWorkUnit.find(params[:id]).features
        @mapped_features = @step.features
      end
    end
		respond_to do |format|
      format.html  { render :partial => 'lba_children',
                            :locals => {:lbas => @business_areas,
             								            :lbos => @business_objects,
      												          :functional_work_units => @functional_work_units,
      													        :features => @features,
      													        :mapped_features => @mapped_features
      																 }
									 }
    end
  end

  private
    def find_step
      @step = Step.find(params[:step_id])
    end

end

