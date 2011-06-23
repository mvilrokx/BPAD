class LbasController < ApplicationController

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
    	elsif (params[:rel] == 'lbo') then
    	  lbo = Lbo.find(params[:id])
     	  @build_features = lbo.build_features
     	  @logical_entities = lbo.logical_entities
    	elsif (params[:rel] == 'le') then
    	  le = LogicalEntity.find(params[:id])
     	  @logical_entity_attributes = le.logical_entity_attributes
    	elsif (params[:rel] == 'build_feature') then
    	  bf = BuildFeature.find(params[:id])
     	  @build_features = bf.children
      end
    end
		respond_to do |format|
      format.html  { render :partial => 'lba_children', :locals => {:lbas => @lbas,
                                                                    :lbos => @lbos,
                                                                    :bfs => @build_features,
                                                                    :les => @logical_entities,
                                                                    :le_attributes => @logical_entity_attributes,
                                                                    :interfaces => @interfaces
      																															}}
    end
  end

  def index
    render :layout => 'tree_with_two_columns'
  end

  def show
    @lba = Lba.find(params[:id])
    if (request.xhr?)
    	render :partial => 'show_details'
    else
    	render :show
    end
  end

  def create
    @lba = Lba.new(params[:lba])
    if @lba.save
      flash[:notice] = "Successfully created lba."
 			render :json => @lba, :layout => false
    else
      render :action => 'new'
    end
  end

  def update
    @lba = Lba.find(params[:id])
    if @lba.update_attributes(params[:lba])
      flash[:notice] = "Successfully updated lba."
 			render :json => @lba, :layout => false
    else
      render :action => 'edit'
    end
  end

  def destroy
    @lba = Lba.find(params[:id])
    @lba.destroy
    flash[:notice] = "Successfully destroyed lba."
    render :nothing => true
  end
end

