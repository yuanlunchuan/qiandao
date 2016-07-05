class EventQuestion < ActiveRecord::Base
  belongs_to :event
  has_many :questions
end
