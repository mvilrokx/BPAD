class LogicalEntitiesController < ApplicationController
  def index
    @logical_entities = LogicalEntity.all
  end

  def show
    @logical_entity = LogicalEntity.find(params[:id])
  end

  def new
    @logical_entity = LogicalEntity.new
  end

  def create
    @logical_entity = LogicalEntity.new(params[:logical_entity])
    if @logical_entity.save
      flash[:notice] = "Successfully created logical entity."
      redirect_to @logical_entity
    else
      render :action => 'new'
    end
  end

  def edit
    @logical_entity = LogicalEntity.find(params[:id])
  end

  def update
    @logical_entity = LogicalEntity.find(params[:id])
    if @logical_entity.update_attributes(params[:logical_entity])
      flash[:notice] = "Successfully updated logical entity."
      redirect_to @logical_entity
    else
      render :action => 'edit'
    end
  end

  def destroy
    @logical_entity = LogicalEntity.find(params[:id])
    @logical_entity.destroy
    flash[:notice] = "Successfully destroyed logical entity."
    redirect_to logical_entities_url
  end
end
