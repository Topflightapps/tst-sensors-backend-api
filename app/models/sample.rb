class Sample < ApplicationRecord

  validate :capture_time_cannnot_be_in_future

  validates :capture_time, uniqueness: { scope: :sensor_id, message: "should be unique for sensor_id" }

  def capture_time_cannnot_be_in_future
    if !capture_time.blank? and capture_time > Time.now
      errors.add(:capture_time, "cannot be in the future")
    end
  end
end
