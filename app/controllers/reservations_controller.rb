class ReservationsController < ApplicationController
  RESERVATION_ATTR = [:date_and_time, :size]
  before_filter -> { load_restaurant(:restaurant_id) }, except: :index  #load_restaurant in application_controller
  before_filter :load_reservation, only: [:edit, :update, :destroy]
  before_filter :ensure_logged_in, only: [:create, :update, :destroy]

  def index
    if current_user
      @reservations = current_user.reservations.order(date_and_time: :asc)
    else
      raise ActionController::RoutingError.new('Not Found')   #hides page from non-registered visitors
    end
  end

  def edit
  end

  def create
    @reservation = @restaurant.reservations.build(secure_params(:reservation, RESERVATION_ATTR))
    @reservation.user = current_user
    if @reservation.save
      redirect_to current_restaurant, notice: 'Reservation created successfully'
    else
      flash.now['alert'] = 'Failure when creating reservation'
      render 'restaurants/show'
    end
  end

  def update 
    if @reservation.update_attributes(secure_params(:reservation, RESERVATION_ATTR))
      redirect_to current_restaurant, notice: 'Reservation updated successfully'
    else
      flash.now['alert'] = 'Failure when updating reservation'
      render :edit
    end
  end

  def destroy
    @reservation.destroy
    redirect_to current_restaurant, notice: "Reservation canceled"
  end

  private
  def load_reservation
    @reservation = Reservation.find(params[:id])
  end

  def current_restaurant
    restaurant_path(@reservation.restaurant_id)  #chose to grab id from active record in case route no longer nested
  end
end
