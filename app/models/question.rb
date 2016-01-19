class Question < ActiveRecord::Base
  belongs_to :session
  belongs_to :attendee
  belongs_to :event

  has_one :answer
end
