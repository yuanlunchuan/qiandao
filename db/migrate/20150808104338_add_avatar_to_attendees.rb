class AddAvatarToAttendees < ActiveRecord::Migration
  def up
    add_attachment :attendees, :avatar
  end

  def down
    remove_attachment :attendees, :avatar
  end
end
