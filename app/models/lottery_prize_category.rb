class LotteryPrizeCategory < ActiveRecord::Base
  belongs_to :event_lottery_prize
  belongs_to :attendee_category
end
