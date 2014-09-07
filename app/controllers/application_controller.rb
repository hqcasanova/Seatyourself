class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  around_filter :to_user_tz, if: :current_user

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

  #Outputs date_time in format similar to Sat, 6 Sep 2014 23:10
  def formatted_datetime(date_time)
    date_time.strftime("%a, %e %b %Y %H:%M")
  end
  helper_method :formatted_datetime

  #Authorisation: Flashes an alert if the user is not logged in.
  def ensure_logged_in
    unless current_user
      flash[:alert] = "Please log in"
      redirect_to new_session_path
    end
  end

  #Sets the time zone context to the user's. From Railscasts PRO #106 (https://www.youtube.com/watch?v=4qxTMg_0QAw)
  def to_user_tz(&block)
    Time.use_zone(current_user.time_zone, &block)
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
