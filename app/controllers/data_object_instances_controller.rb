class DataObjectInstancesController < ApplicationController
  def index
    @data_object_instances = DataObjectInstance.all
  end

  def show
    @data_object_instance = DataObjectInstance.find(params[:id])
  end

  def new
    @data_object_instance = DataObjectInstance.new
  end

  def create
    @data_object_instance = DataObjectInstance.new(params[:data_object_instance])
    if @data_object_instance.save
      flash[:notice] = "Successfully created data object instance."
      redirect_to @data_object_instance
    else
      render :action => 'new'
    end
  end

  def edit
    @data_object_instance = DataObjectInstance.find(params[:id])
  end

  def update
    @data_object_instance = DataObjectInstance.find(params[:id])
    if @data_object_instance.update_attributes(params[:data_object_instance])
      flash[:notice] = "Successfully updated data object instance."
      redirect_to @data_object_instance
    else
      render :action => 'edit'
    end
  end

  def destroy
    @data_object_instance = DataObjectInstance.find(params[:id])
    @data_object_instance.destroy
    flash[:notice] = "Successfully destroyed data object instance."
    redirect_to data_object_instances_url
  end
end
