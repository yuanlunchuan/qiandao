class CreateRecommends < ActiveRecord::Migration
  def change
    create_table :recommends do |t|

      t.references :event

      t.string :category_name
      t.string :recommend_name
      t.string :address
      t.string :phone_number
      t.integer :distance

      t.timestamps null: false
    end
  end
end
