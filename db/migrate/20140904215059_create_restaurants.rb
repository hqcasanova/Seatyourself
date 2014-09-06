class CreateRestaurants < ActiveRecord::Migration
  def change
    create_table :restaurants do |t|
      t.string :name
      t.string :address
      t.string :owner
      t.integer :capacity

      t.timestamps
    end
  end
end
