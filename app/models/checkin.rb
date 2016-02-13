class Checkin < ActiveRecord::Base
  belongs_to :session
  belongs_to :attendee

  before_create :populate_time
  scope :checkin_is, ->(session, attendee) { where "attendee_id=? AND session_id=?", attendee.id, session.id }

private
  def populate_time
    self.checked_in_at = Time.now
  end
end
