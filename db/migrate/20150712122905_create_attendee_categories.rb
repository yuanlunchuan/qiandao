class CreateAttendeeCategories < ActiveRecord::Migration
  def change
    create_table :attendee_categories do |t|
      t.string    :name
      t.references :event
      t.timestamps null: false
      t.integer   :category_number
    end
  end
end
