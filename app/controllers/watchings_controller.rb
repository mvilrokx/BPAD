class WatchingsController < ApplicationController
  def index
    @watchings = Watching.all
  end

  def show
    @watching = Watching.find(params[:id])
  end

  def new
    @watchable = find_watchable
    @watching = @watchable.watchings.new
    @watching.user_id = current_user.id
  end

  def create
    @watchable = find_watchable
    @watching = @watchable.watchings.build(params[:watching])
    @watching.user_id = current_user.id
    if @watching.save
      flash[:notice] = "Successfully created watching."
      if request.xhr?
        render :json => @watching
      else
        redirect_to @watchable
      end
    else
      render :action => 'new'
    end
  end

#  def create
#    @watching = Watching.new(params[:watching])
#    if @watching.save
#      flash[:notice] = "Successfully created watching."
#      redirect_to @watching
#    else
#      render :action => 'new'
#    end
#  end

  def edit
    @watching = Watching.find(params[:id])
  end

  def update
    @watching = Watching.find(params[:id])
    if @watching.update_attributes(params[:watching])
      flash[:notice] = "Successfully updated watching."
      redirect_to @watching
    else
      render :action => 'edit'
    end
  end

  def destroy
    @watchable = find_watchable
    @watching = @watchable.watchings.find(params[:id])
    @watching.destroy
    flash[:notice] = "Successfully destroyed watching."
    if request.xhr?
      render :json => @watching
    else
      redirect_to watchings_url
    end
  end

  def change_owner
    @watchable = find_watchable
    @current_owner = @watchable.watchings.find(:first, {:conditions => ["creator = 1"]})
    if @current_owner
      @current_owner.update_attributes(:creator => false)
    end
    if @new_owner = @watchable.watchings.find_by_user_id(current_user.id)
      @new_owner.update_attributes(:creator => true)
    else
      @new_owner = @watchable.watchings.create(:user_id => current_user.id, :creator => true)
    end
    if request.xhr?
      render :json => @watchable.owner
    else
      redirect_to business_areas_url
    end
  end


  private

    def find_watchable
      params.each do |name, value|
        if name =~ /(.+)_id$/
          return $1.pluralize.classify.constantize.find(value)
        end
      end
      nil
    end

end
