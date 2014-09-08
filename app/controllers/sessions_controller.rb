class SessionsController < ApplicationController
  def new
    cookies[:url_before_login] = request.referrer
  end

  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      url_before_login = cookies[:url_before_login]
      if !url_before_login.blank?       #redirect to page previous to login if cookies enabled (quasi-seamless login)
        redirect_to url_before_login, notice: "Logged in!"
        cookies.delete :url_before_login
      else  
        redirect_to reservations_path, notice: "Logged in!"
      end
    else
      flash.now[:alert] = "Invalid email or password"
      render "new"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_page = request.referrer 
    if redirect_page == reservations_url
      redirect_page = restaurants_path
    end 
    redirect_to redirect_page, notice: "Logged out!"
  end
end
