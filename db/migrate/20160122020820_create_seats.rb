class CreateSeats < ActiveRecord::Migration
  def change
    create_table :seats do |t|

      t.references :session
      
      t.integer :table_num
      t.integer :per_table_num

      t.timestamps null: false
    end
  end
end
