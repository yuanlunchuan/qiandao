class Seat < ActiveRecord::Base

  belongs_to :session
  belongs_to :attendee

  scope :session_is, ->(session) { where session_id: session.id }
  scope :seat_position_is, ->(row, col) { where "table_row=? AND table_col=?", row, col }

end
