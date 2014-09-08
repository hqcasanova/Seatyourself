class RestaurantsController < ApplicationController
  RESTAURANT_ATTR = [:name, :address, :business_number, :capacity, {:cuisine_ids => []}]
  before_filter -> { load_restaurant(:id) }, only: [:show, :edit, :update, :destroy]

  def index
    @restaurants = Restaurant.all
  end

  def show
    if current_user
      @reservation = @restaurant.reservations.build
    end
  end

  def new
    @restaurant = Restaurant.new
  end

  def edit
  end

  def create
    @restaurant = Restaurant.new(secure_params(:restaurant, RESTAURANT_ATTR))
    if @restaurant.save
      redirect_to restaurants_path, notice: "Restaurant created successfully"
    else
      flash.now['alert'] = 'Failure when creating restaurant'
      render :new
    end
  end

  def update
    if @restaurant.update_attributes(secure_params(:restaurant, RESTAURANT_ATTR))
      redirect_to restaurant_path, notice: "Restaurant updated successfully"
    else
      flash.now['alert'] = 'Failure when updating restaurant'
      render :edit
    end
  end

  def destroy
    @restaurant.destroy
    redirect_to restaurants_path, notice: "Restaurant deleted"
  end
end
