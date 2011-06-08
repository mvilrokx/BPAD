class LogicalEntityAttributesController < ApplicationController
  def index
    @logical_entity_attributes = LogicalEntityAttribute.all
  end

  def show
    @logical_entity_attribute = LogicalEntityAttribute.find(params[:id])
  end

  def new
    @logical_entity_attribute = LogicalEntityAttribute.new
  end

  def create
    @logical_entity_attribute = LogicalEntityAttribute.new(params[:logical_entity_attribute])
    if @logical_entity_attribute.save
      flash[:notice] = "Successfully created logical entity attribute."
      redirect_to @logical_entity_attribute
    else
      render :action => 'new'
    end
  end

  def edit
    @logical_entity_attribute = LogicalEntityAttribute.find(params[:id])
  end

  def update
    @logical_entity_attribute = LogicalEntityAttribute.find(params[:id])
    if @logical_entity_attribute.update_attributes(params[:logical_entity_attribute])
      flash[:notice] = "Successfully updated logical entity attribute."
      redirect_to @logical_entity_attribute
    else
      render :action => 'edit'
    end
  end

  def destroy
    @logical_entity_attribute = LogicalEntityAttribute.find(params[:id])
    @logical_entity_attribute.destroy
    flash[:notice] = "Successfully destroyed logical entity attribute."
    redirect_to logical_entity_attributes_url
  end
end
