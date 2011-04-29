class FlowsController < ApplicationController
  def index
    @flows = Flow.all
  end

  def show
    @flow = Flow.find(params[:id])
  end

  def new
    @flow = Flow.new
  end

  def create
    @flow = Flow.new(params[:flow])
    if @flow.save
      flash[:notice] = "Successfully created flow."
      redirect_to @flow
    else
      render :action => 'new'
    end
  end

  def edit
    @flow = Flow.find(params[:id])
  end

  def update
    @flow = Flow.find(params[:id])
    if @flow.update_attributes(params[:flow])
      flash[:notice] = "Successfully updated flow."
      redirect_to @flow
    else
      render :action => 'edit'
    end
  end

  def destroy
    @flow = Flow.find(params[:id])
    @flow.destroy
    flash[:notice] = "Successfully destroyed flow."
    redirect_to flows_url
  end
end
