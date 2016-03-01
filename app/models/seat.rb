class Seat < ActiveRecord::Base

  belongs_to :session
  belongs_to :attendee

  scope :attendee_seat_is, ->(attendee, session) { where "attendee_id=? AND session_id=?", attendee.id, session.id }
  scope :session_is, ->(session) { where session_id: session.id }
  scope :seat_position_is, ->(row, col) { where "table_row=? AND table_col=?", row, col }
  scope :seat_by_row, ->(row) { where "table_row=?", row }
  scope :search_by_session_row, ->(session, table_row) { where "session_id=? AND table_row=?", session.id, table_row }

  #查询出超过当前座位安排的人
  scope :should_delete, ->(current_row, current_col) { where "table_row>? OR table_col>?", current_row, current_col }

  def to_hash
    hash = {}
    self.attributes.each { |k,v| hash[k] = v }
    return hash
  end
end
