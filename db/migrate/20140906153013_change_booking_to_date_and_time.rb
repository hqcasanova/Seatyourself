class ChangeBookingToDateAndTime < ActiveRecord::Migration
  def change
    rename_column :reservations, :booking, :date_and_time
  end
end
