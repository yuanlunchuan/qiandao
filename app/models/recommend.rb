class Recommend < ActiveRecord::Base
  belongs_to :event
  validates :category_name, presence: true
  validates :recommend_name, presence: true
  validates :address, presence: true
  validates :distance, presence: true
end
