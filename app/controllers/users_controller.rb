class UsersController < ApplicationController
  USER_ATTR = [:name, :username, :email, :password, :password_confirmation, :time_zone]

  def new
    @user = User.new
  end

  def create
    @user = User.new(secure_params(:user, USER_ATTR))
    if @user.save 
      redirect_to restaurants_path, notice: "Signed up!"
    else
      render 'new'
    end
  end
end
