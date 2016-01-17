class CreateSessions < ActiveRecord::Migration
  def change
    create_table :sessions do |t|
      t.string :name
      t.references :event
      t.datetime :starts_at
      t.datetime :ends_at
      t.string :location
      t.text :desc

      t.boolean :checkin_enabled
      t.boolean :hidden, default: false
      t.boolean :company_checkin, default: false

      t.timestamps null: false
    end
  end
end
