class AddDisplayToSessionSeats < ActiveRecord::Migration
  def change
    add_column :session_seats, :display, :boolean
  end
end
