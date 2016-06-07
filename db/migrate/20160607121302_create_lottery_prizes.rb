class CreateLotteryPrizes < ActiveRecord::Migration
  def change
    create_table :lottery_prizes do |t|
      t.references :event
      t.references :attendee
      t.references :event_lottery_prize_item
      t.references :event_lottery_prize

      t.timestamps null: false
    end
  end
end
