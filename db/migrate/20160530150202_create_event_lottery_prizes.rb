class CreateEventLotteryPrizes < ActiveRecord::Migration
  def change
    create_table :event_lottery_prizes do |t| 
      t.references :event
      t.string :lottery_prize_name
      t.integer :lottery_prize_acount

      t.timestamps null: false
    end
  end
end
