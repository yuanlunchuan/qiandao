class Question < ActiveRecord::Base
  belongs_to :event_question
  belongs_to :attendee
  belongs_to :event
  has_many :attendee_praises_questions

  has_one :answer
end
