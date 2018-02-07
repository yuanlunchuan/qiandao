class Seller < ActiveRecord::Base
  validates :name, presence: true
  validates :phone_number, presence: true, length: { is: 11 }, numericality: { integer_only: true }, format: { with: /\A1[3-9]\d{9}\z/ }
  has_many :subordinates, class_name: "Seller",
                          foreign_key: "seller_id"

  belongs_to :manager, class_name: "Seller"

  belongs_to :event
  has_many   :attendees

  scope :phone_and_event_is, ->(phone_number, event) { where "phone_number=? AND event_id=?", phone_number, event.id }

  scope :seller_name_is, ->(name) { where name: name }
  scope :phone_number_is, -> (phone_number) { where phone_number: phone_number }
end
