class Seat < ActiveRecord::Base

  belongs_to :session
  belongs_to :attendee

  scope :attendee_seat_is, ->(attendee, session) { where "attendee_id=? AND session_id=?", attendee.id, session.id }
  scope :session_is, ->(session) { where session_id: session.id }
  scope :seat_position_is, ->(row, col) { where "table_row=? AND table_col=?", row, col }
  scope :seat_by_row, ->(row) { where "table_row=?", row }
  def to_hash
    hash = {}
    self.attributes.each { |k,v| hash[k] = v }
    return hash
  end
end
