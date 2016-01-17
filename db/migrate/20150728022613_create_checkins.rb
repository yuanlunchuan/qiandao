class CreateCheckins < ActiveRecord::Migration
  def change
    create_table :checkins do |t|
      t.references :session, index: true, foreign_key: true
      t.references :attendee, index: true, foreign_key: true
      t.datetime :checked_in_at

      t.timestamps null: false
    end
  end
end
