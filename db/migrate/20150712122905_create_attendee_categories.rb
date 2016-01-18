class CreateAttendeeCategories < ActiveRecord::Migration
  def change
    create_table :attendee_categories do |t|
      t.string     :name
      t.references :event
      t.integer    :category_number
      t.string     :category_color

      t.timestamps null: false
    end
  end
end
