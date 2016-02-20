class AddPropertiesToSessionSeats < ActiveRecord::Migration
  def change
    add_column :session_seats, :properties, :json, default: {}
  end
end
