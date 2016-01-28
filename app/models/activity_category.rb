class ActivityCategory < ActiveRecord::Base
  has_many   :activities
  belongs_to :event

  validates :name, presence: true
end
