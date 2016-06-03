class EventLotteryPrize < ActiveRecord::Base
  belongs_to :event
  has_many :event_lottery_prize_items
end
