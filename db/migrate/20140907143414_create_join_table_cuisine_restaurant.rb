class CreateJoinTableCuisineRestaurant < ActiveRecord::Migration
  def change
    create_table :cuisines_restaurants, :id => false do |t|
      t.integer :cuisine_id
      t.integer :restaurant_id
    end
  end
end
