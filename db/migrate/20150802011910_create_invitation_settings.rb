class CreateInvitationSettings < ActiveRecord::Migration
  def change
    create_table :invitation_settings do |t|
      t.references :event
      t.text   :content
      t.string :date
      t.string :check_in_time
      t.string :location
      t.string :address
      t.string :map_url, limit: 1000
      t.text   :qr_tip
      t.string :event_alias

      #---------------------
      t.attachment :photo
      t.string     :token
      t.integer  :attendee_number, default: 0
      #----------------------

      t.timestamps null: false
    end
  end
end
