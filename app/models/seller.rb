class Seller < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  validates :phone_number, presence: true, uniqueness: true

  has_many :subordinates, class_name: "Seller",
                          foreign_key: "seller_id"

  belongs_to :manager, class_name: "Seller"

  belongs_to :event

  scope :seller_name_is, ->(name) { where name: name }
end
