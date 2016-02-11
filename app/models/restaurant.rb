class Restaurant < ActiveRecord::Base
  belongs_to :event
  #validates :phone_number, presence: true, numericality: { integer_only: true }
end
