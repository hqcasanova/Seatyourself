class CreateReservations < ActiveRecord::Migration
  def change
    create_table :reservations do |t|
      t.datetime :booking
      t.integer :size
      t.references :restaurant, index: true
      t.references :user, index: true

      t.timestamps
    end
  end
end
