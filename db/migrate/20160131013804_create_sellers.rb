class CreateSellers < ActiveRecord::Migration
  def change
    create_table :sellers do |t|
      t.references :manager
      t.references :event

      t.string :name
      t.string :responsible_area
      t.string :phone_number

      t.timestamps null: false
    end
  end
end
