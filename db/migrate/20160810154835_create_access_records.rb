class CreateAccessRecords < ActiveRecord::Migration
  def change
    create_table :access_records do |t|

      t.string :ip_address
      t.integer :access_count,  default: 0
      t.boolean :is_trust, default: true
      t.boolean :is_notification, default: false

      t.timestamps null: false
    end
  end
end
