class AddRestaurantBackgroundToRestaurant < ActiveRecord::Migration
  def change
    add_attachment :restaurants, :head_photo
  end
end
