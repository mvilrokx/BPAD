class InterfacesController < ApplicationController
  def index
    @interfaces = Interface.all
  end

  def show
    @interface = Interface.find(params[:id])
  end

  def new
    @interface = Interface.new
  end

  def create
    @interface = Interface.new(params[:interface])
    if @interface.save
      flash[:notice] = "Successfully created interface."
      redirect_to @interface
    else
      render :action => 'new'
    end
  end

  def edit
    @interface = Interface.find(params[:id])
  end

  def update
    @interface = Interface.find(params[:id])
    if @interface.update_attributes(params[:interface])
      flash[:notice] = "Successfully updated interface."
      redirect_to @interface
    else
      render :action => 'edit'
    end
  end

  def destroy
    @interface = Interface.find(params[:id])
    @interface.destroy
    flash[:notice] = "Successfully destroyed interface."
    redirect_to interfaces_url
  end
end
