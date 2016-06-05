class CreateLotteryPrizeCategories < ActiveRecord::Migration
  def change
    create_table :lottery_prize_categories do |t|
      t.references :event_lottery_prize
      t.references :attendee_category
      t.timestamps null: false
    end
  end
end
