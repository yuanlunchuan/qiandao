class AddBaseInfoToEvents < ActiveRecord::Migration
  def change
    add_column :events, :domain_name, :string
    add_column :events, :title, :string
    add_column :events, :content, :text
    add_attachment :events, :head_photo
    add_attachment :events, :event_logo
    add_column :events, :display_welcome_page, :boolean
    add_attachment :events, :welcome_page_logo
    add_attachment :events, :welcome_bg
    add_column :events, :admission_certificate, :boolean
    add_column :events, :session_schedule, :boolean
    add_column :events, :hotel_info, :boolean
    add_column :events, :nearby_recommend, :boolean
    add_column :events, :seat_info, :boolean
    add_column :events, :outside_link, :boolean
    add_column :events, :interactive_answer, :boolean
    add_column :events, :lottery, :boolean

  end
end
