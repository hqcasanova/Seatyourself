class Restaurant < ActiveRecord::Base
  
  #Associations
  has_many :reservations
  has_many :users, through: :reservations
  has_and_belongs_to_many :cuisines
  
  #Validation
  validates :name, :address, :capacity, presence: true
  validates :name,              #assumed English alphabet
    length: { maximum: 100 },
    format: { with: /\A[a-zA-Z\s\-]*\Z/, message: 'must be alphabetical' }    
  validates :address,           #assumed English alphabet, catch-all field for all info (incl. postcode)
    length: { maximum: 300 },
    format: { with: /\A[A-Za-z\d\s\-,#.\/]*\Z/, message: 'must be alphanumeric' }    
  validates :capacity, numericality: { :greater_than => 0, :only_integer => true }
  validates :business_number,   #TODO: this together with a has_and_belongs_to_many association with an Owner 
    length: { is: 9 },          #model would allow basic discrimination between owners and plain users 
    :allow_blank => true,       #and, by extension, better authorization 
    numericality: { :greater_than_or_equal_to => 0, :only_integer => true }
  validate :at_least_one_cuisine

  #Capacity is assumed to refer to that during a certain time slot. The latter is defined by a starting
  #date_and_time plus a certain time length, presumed to be equal across all reservations. That time length
  #is 1 hour. All this translates into simpler criteria when calculating current remaining capacity: consider 
  #only reservations with same date and time.
  def available?(size, date_and_time)
    reserved = reservations.where(date_and_time: date_and_time).sum(:size)
    reserved + size <= capacity
  end

  #All restaurants are expected to specialize in one or more cuisines.
  private
  def at_least_one_cuisine
    errors.add(:base, 'You must select at least one type of cuisine') if cuisines.blank?
  end
end
