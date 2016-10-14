class AttendeePraisesQuestion < ActiveRecord::Base
  belongs_to :attendee
  belongs_to :question
  belongs_to :event_question
  scope :get_praise, ->(attendee, question) { where "attendee_id=? AND question_id=?", attendee.id, question.id }
end
