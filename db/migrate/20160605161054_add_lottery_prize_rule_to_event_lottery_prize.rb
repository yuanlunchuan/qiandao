class AddLotteryPrizeRuleToEventLotteryPrize < ActiveRecord::Migration
  def change
    add_column :event_lottery_prizes, :allow_attendee_repeat_take_in, :boolean, default: false
    add_column :event_lottery_prizes, :lottery_prize_method, :string, default: 'attendee'
  end
end
