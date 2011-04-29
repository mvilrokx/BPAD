# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include Authentication
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  before_filter :set_current_user_for_observer

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

  def set_current_user_for_observer
    WatchingObserver.current_user = session[:user_id]
  end

  def sort_direction
	  %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end

  def sort_column(object)
    object.column_names.include?(params[:sort_by]) ? params[:sort_by] : "updated_at"
	end

end
