class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.date :start
      t.date :end
      t.boolean :enabled

      t.text   :desc
      t.string :location
      t.string :contact
      t.string :contact_number
      t.string :event_link

      t.string :time_zone, default: 'Beijing'
      t.datetime :starts_at
      t.datetime :ends_at

      t.timestamps null: false
    end
  end
end
