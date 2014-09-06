class User < ActiveRecord::Base
  
  #Associations
  has_many :reservations
  has_many :restaurants, through: :reservations
  has_secure_password

  #Validation
  validates :timezone, presence: true
  validates :email, :username,
    presence: true, 
    uniqueness: true
  validates :username, #assumed English alphabet
    length: { maximum: 25 },
    format: { with: /\A[A-Za-z\d]*([A-Za-z\d]+[\-|_][A-Za-z\d]+)*\Z/, message: 'can only be unspaced letters and numbers optionally separated by a dash or underscore' }
  validates :name,     #assumed English alphabet
    length: { maximum: 100 },
    format: { with: /\A[a-zA-Z\s\-]*\Z/, message: 'must be alphabetical' }
  validates :password_confirmation, presence: true
end
