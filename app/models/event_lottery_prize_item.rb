class EventLotteryPrizeItem < ActiveRecord::Base
  belongs_to :event_lottery_prize
  has_many :lottery_prizes
end
