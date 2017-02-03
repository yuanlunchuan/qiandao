class AddSeatBgToEvents < ActiveRecord::Migration
  def change
    add_attachment :events, :seat_search_bg
  end
end
