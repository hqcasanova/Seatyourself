class Restaurant < ActiveRecord::Base
  
  #Associations
  has_many :reservations
  has_many :users, through: :reservations
  has_and_belongs_to_many :cuisines
  
  #Validation
  validates :name, :address, :capacity, presence: true
  validates :name,            #assumed English alphabet
    length: { maximum: 100 },
    format: { with: /\A[a-zA-Z\s\-]*\Z/, message: 'must be alphabetical' }    
  validates :address,         #assumed English alphabet, catch-all field for all info (incl. postcode)
    length: { maximum: 300 },
    format: { with: /\A[A-Za-z\d\s\-,#.\/]*\Z/, message: 'must be alphanumeric' }    
  validates :capacity, numericality: { :greater_than => 0, :only_integer => true }
  validates :business_number, 
    length: { is: 9 },
    :allow_blank => true, 
    numericality: { :greater_than_or_equal_to => 0, :only_integer => true }
  validate :at_least_one_cuisine

  private
  def at_least_one_cuisine
      errors.add(:base, 'You must select at least one type of cuisine') if cuisines.blank?
  end
end
