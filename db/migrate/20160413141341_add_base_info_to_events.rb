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
  end
end
