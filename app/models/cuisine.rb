class Cuisine < ActiveRecord::Base

  #Associations
  has_and_belongs_to_many :restaurants

  
end
