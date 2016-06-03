class CreateEventLotteryPrizes < ActiveRecord::Migration
  def change
    create_table :event_lottery_prizes do |t| 
      t.references :event
      t.string :name
      t.text :comment

      t.timestamps null: false
    end
  end
end
