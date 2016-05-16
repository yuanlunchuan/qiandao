class AddSessionLocationToSessions < ActiveRecord::Migration
  def change
  	add_reference :sessions, :session_location
  end
end
