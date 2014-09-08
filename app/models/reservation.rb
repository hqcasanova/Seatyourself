class Reservation < ActiveRecord::Base
  
  #Associations
  belongs_to :user
  belongs_to :restaurant

  #Validation
  validates :size,
    presence: true,
    :numericality => { :only_integer => true, :greater_than => 0 }
  validate :size, :availability
  validate :date_and_time, :not_past_within_business
  
  private
  def availability
    if size.present? && date_and_time.present?
      unless restaurant.available?(size, date_and_time)
        errors.add(:base, "Restaurant is full. Either choose another date/restaurant or decrease the reservation's size")
      end
    end
  end

  def not_past_within_business
    if !date_and_time.present?                        #not left blank?
      errors.add(:date_and_time, "must be provided")
    else                                              #not in the past?
      now = Time.zone.now.change(sec: 0)
      booking = date_and_time.change(sec: 0)          #a difference of a few seconds between reservations doesn't make them distinct
      if booking <= now                               #simplifies things when doing capacity calculations (summing up reservation sizes for the same time slot)
        errors.add(:date_and_time, "must be in the future: current = #{now} provided = #{booking}")
      end
      if booking.hour > 20 || booking.hour < 11    #within business hours? Assumed to be between 11-20 every day
        errors.add(:date_and_time, "should be within business hours (assumed to be 11:00-20:00)")
      end
    end
  end
end
