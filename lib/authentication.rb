# This module is included in your application controller which makes
# several methods available to all controllers and views. Here's a
# common example you might add to your application layout file.
#
#   <% if logged_in? %>
#     Welcome <%=h current_user.username %>! Not you?
#     <%= link_to "Log out", logout_path %>
#   <% else %>
#     <%= link_to "Sign up", signup_path %> or
#     <%= link_to "log in", login_path %>.
#   <% end %>
#
# You can also restrict unregistered users from accessing a controller using
# a before filter. For example.
#
#   before_filter :login_required, :except => [:index, :show]
module Authentication
  def self.included(controller)
     controller.send :helper_method, :current_user, :logged_in?, :working_on_iteration?, :redirect_to_target_or_default
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    current_user
  end

  def working_on_iteration?
    current_user.iteration_id
  end

  def login_required
    unless logged_in?
      flash[:error] = "You must first log in or sign up before accessing this page."
      store_target_location
      redirect_to login_url
    end
  end

  def iteration_required
	  login_required
    unless working_on_iteration?
      flash[:error] = "You must select an iteration to work on before accessing this page."
      store_target_location
      redirect_to edit_user_url(current_user)
    end
  end

  def redirect_to_target_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

  private

  def store_target_location
    session[:return_to] = request.request_uri
  end
end

