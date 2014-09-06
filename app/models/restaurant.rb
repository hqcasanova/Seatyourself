class Restaurant < ActiveRecord::Base
  
  #Associations
  has_many :reservations
  has_many :users, through: :reservations
  
  #Validation
  validates :name, :address, :capacity, presence: true
  validates :name,            #assumed English alphabet
    length: { maximum: 100 },
    format: { with: /\A[a-zA-Z\s\-]*\Z/, message: 'must be alphabetical' }    
  validates :address,         #assumed English alphabet, catch-all field for all info (incl. postcode)
    length: { maximum: 300 },
    format: { with: /\A[A-Za-z\d\s\-,#.\/]*\Z/, message: 'must be alphanumeric' }    
  validates :capacity, numericality: {only_integer: true}
  validates :business_number, 
    length: { is: 9 },
    :allow_blank => true, 
    numericality: {only_integer: true}
end
