class CreateSeats < ActiveRecord::Migration
  def change
    create_table :seats do |t|

      t.references :session
      t.references :attendee

      t.integer :table_row
      t.integer :table_col
      t.string  :desc

      t.timestamps null: false
    end
  end
end
