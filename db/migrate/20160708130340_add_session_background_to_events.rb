class AddSessionBackgroundToEvents < ActiveRecord::Migration
  def change
    add_attachment :events, :welcome_second_bg
    add_attachment :events, :sessions_new_bg
  end
end
