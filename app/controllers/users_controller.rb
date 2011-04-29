class UsersController < ApplicationController

  def show
    @user = User.find(params[:id], :include => :watchings)
  end

  def new
    @user = User.new
    @iterations = Iteration.active
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      session[:user_id] = @user.id
      flash[:notice] = "Thank you for signing up! You are now logged in."
      redirect_to root_url
    else
      render :action => 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
    @iterations = Iteration.active
  end

  def update
	  params[:user][:role_ids] ||= []
    @user = User.find(params[:id])
#    @iterations = Iteration.active||=[]
    if @user.update_attributes(params[:user])
      flash[:notice] = "Successfully updated your account."
      render :action => 'edit'
    else
      render :action => 'new'
    end
  end

end
