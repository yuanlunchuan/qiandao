class Recommend < ActiveRecord::Base
  belongs_to :event
  validates :phone_number, presence: true, length: { is: 11 }, numericality: { integer_only: true }, format: { with: /\A1[3-9]\d{9}\z/ }
  validates :category_name, presence: true
  validates :recommend_name, presence: true
  validates :address, presence: true
  validates :distance, presence: true
end
