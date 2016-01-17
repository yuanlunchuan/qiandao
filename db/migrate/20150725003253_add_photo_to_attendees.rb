class AddPhotoToAttendees < ActiveRecord::Migration
  def up
    add_attachment :attendees, :photo
  end

  def down
    remove_attachment :attendees, :photo
  end
end
