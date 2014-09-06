class RemoveOwnerFromRestaurants < ActiveRecord::Migration
  def change
    remove_column :restaurants, :owner, :string
  end
end
