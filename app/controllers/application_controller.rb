class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def back_url
    if (controller_name == 'sessions') || (controller_name == 'users')
      url = controller_name + '/new'
    elsif (request.referrer != request.path)
      url = request.referrer
    elsif (controller_name != 'sessions') && (controller_name != 'users')
      url = root_path + controller_name
    else 
      url = root_path 
    end 
  end
  helper_method :back_url

  #Fetches the current user if not done already 
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user

  #Authorisation: Flashes an alert if the user is not logged in.
  def ensure_logged_in
    unless current_user
      flash[:alert] = "Please log in"
      redirect_to new_session_path
    end
  end

  #Sanitized version of params
  def secure_params(require_param, permit_keys)
    params.require(require_param).permit(*permit_keys)
  end

  #Fetches the current restaurant.
  def load_restaurant(id_symbol)
    @restaurant = Restaurant.find(params[id_symbol])
  end
end
