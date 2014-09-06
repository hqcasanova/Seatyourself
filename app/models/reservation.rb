class Reservation < ActiveRecord::Base
  
  #Associations
  belongs_to :user
  belongs_to :restaurant

  #Validation
  validates :size,
    presence: true,   
    :numericality => {:only_integer => true}
  validate :date_and_time, :present_not_past

  def present_not_past
    if !date_and_time.present?
      errors.add(:date_and_time, "must be provided")
    elsif date_and_time < Time.zone.now
      errors.add(:date_and_time, "cannot be in the past: current=#{Time.zone.now} provided=#{date_and_time}")
    end
  end
end
