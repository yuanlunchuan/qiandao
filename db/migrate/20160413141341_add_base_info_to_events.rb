class AddBaseInfoToEvents < ActiveRecord::Migration
  def change
    add_column :events, :domain_name, :string
    add_column :events, :title, :string
    add_column :events, :content, :text
    add_attachment :events, :head_photo
    add_attachment :events, :event_logo
  end
end
