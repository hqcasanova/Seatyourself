class Reservation < ActiveRecord::Base
  
  #Associations
  belongs_to :user
  belongs_to :restaurant

  #Validation
  validates :size,
    presence: true,   
    :numericality => { :greater_than => 0, :only_integer => true }
  validate :date_and_time, :present_not_past

  def present_not_past
    if !date_and_time.present?
      errors.add(:date_and_time, "must be provided")
    else
      now = Time.zone.now.change(sec: 0)
      booking = date_and_time.change(sec: 0)
      if booking <= now
        errors.add(:date_and_time, "must be in the future: current=#{now} provided=#{booking}")
      end
    end
  end
end
