class CreateRestaurants < ActiveRecord::Migration
  def change
    create_table :restaurants do |t|
      t.references :event

      t.string :restaurant_name
      t.string :phone_number
      t.string :address
      t.string :map_url, limit: 1000
      t.float  :latitude
      t.float  :longitude

      t.timestamps null: false
    end
  end
end
