class EventQuestion < ActiveRecord::Base
  belongs_to :event
  has_many :questions
  has_many :attendee_praises_questions

  scope :active, -> { where(active: true) }
end
