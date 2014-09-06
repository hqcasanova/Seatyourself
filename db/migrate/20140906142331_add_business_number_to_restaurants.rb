class AddBusinessNumberToRestaurants < ActiveRecord::Migration
  def change
    add_column :restaurants, :business_number, :integer
  end
end
