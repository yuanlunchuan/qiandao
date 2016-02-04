class CreateSessionSeats < ActiveRecord::Migration
  def change
    create_table :session_seats do |t|
      t.references :session

      t.integer :total_table_count
      t.integer :per_table_num

      t.timestamps null: false
    end
  end
end
