class AddStateToLotteryPrize < ActiveRecord::Migration
  def change
    add_column :lottery_prizes, :state, :string, default: 'C'
  end
end
