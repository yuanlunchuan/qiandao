class CreateSessionLocations < ActiveRecord::Migration
  def change
    create_table :session_locations do |t|
      t.references :event

      t.string :location_name
      t.timestamps null: false
    end
  end
end
