class Seat < ActiveRecord::Base

  belongs_to :session
  belongs_to :attendee

  scope :session_is, ->(session) { where session_id: session.id }

end
