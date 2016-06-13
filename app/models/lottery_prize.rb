class LotteryPrize < ActiveRecord::Base
  belongs_to :event
  belongs_to :attendee
  belongs_to :event_lottery_prize_item
  belongs_to :event_lottery_prize
  scope :search_by_attendee_and_event_lottery_prize, -> (attendee, event_lottery_prize) { where("attendee_id=? AND event_lottery_prize_id=?", attendee.id, event_lottery_prize.id) }
  scope :is_specify, -> { where "is_specify = true" }
  scope :attendee_is, ->(attendee){ where "attendee_id = ?", attendee.id  }
end
