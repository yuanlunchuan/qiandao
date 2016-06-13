class AddIsSpecifyToLotteryPrize < ActiveRecord::Migration
  def change
    add_column :lottery_prizes, :is_specify, :boolean, default: false
  end
end
