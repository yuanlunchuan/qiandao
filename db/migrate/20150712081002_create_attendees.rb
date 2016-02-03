class CreateAttendees < ActiveRecord::Migration
  def change
    create_table :attendees do |t|
      t.string     :name
      t.string     :company
      t.string     :mobile
      t.string     :email
      t.string     :id_photo
      t.references :event
      t.references :category
      t.references :owner_attendee
      t.references :seller
      t.string     :token
      t.string     :rfid_num
      t.string     :level

      t.datetime :checked_in_at
      t.integer  :attendee_number, default: 0

      t.integer  :sms_sid
      t.string   :sms_mobile
      t.datetime :sms_sent_at
      t.boolean  :sms_delivered
      t.datetime :sms_delivered_at
      t.boolean  :sms_failed
      t.string   :sms_error
      
      t.string  :invitation_short_url
      t.integer :gender_id, default: 0
      t.string  :province
      t.string  :city

      t.datetime :printed_at

      t.timestamps null: false
    end
  end
end
