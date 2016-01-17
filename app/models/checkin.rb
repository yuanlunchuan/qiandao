class Checkin < ActiveRecord::Base
  belongs_to :session
  belongs_to :attendee

  before_create :populate_time

private
  def populate_time
    self.checked_in_at = Time.now
  end
end
