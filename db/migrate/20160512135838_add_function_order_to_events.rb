class AddFunctionOrderToEvents < ActiveRecord::Migration
  def change
    add_column :events, :admission_certificate_order, :integer, default: 1
    add_column :events, :session_schedule_order, :integer, default: 2
    add_column :events, :hotel_info_order, :integer, default: 3
    add_column :events, :nearby_recommend_order, :integer, default: 4
    add_column :events, :seat_info_order, :integer, default: 5
    add_column :events, :outside_link_order, :integer, default: 6
    add_column :events, :interactive_answer_order, :integer, default: 7
    add_column :events, :lottery_order, :integer, default: 8
  end
end
