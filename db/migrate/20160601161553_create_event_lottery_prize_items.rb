class CreateEventLotteryPrizeItems < ActiveRecord::Migration
  def change
    create_table :event_lottery_prize_items do |t|
      t.references :event_lottery_prize
      t.string :name
      t.integer :count
      t.timestamps null: false
    end
  end
end
