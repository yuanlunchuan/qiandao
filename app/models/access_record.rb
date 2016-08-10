class AccessRecord < ActiveRecord::Base
  scope :white_list, -> { where(is_trust: true) }
  scope :black_list, -> { where(is_trust: false) }
  scope :ip_address_is, ->(ip_address) { where "ip_address=?", ip_address }
end
