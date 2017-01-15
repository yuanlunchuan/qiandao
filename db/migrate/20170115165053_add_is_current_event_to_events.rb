class AddIsCurrentEventToEvents < ActiveRecord::Migration
  def change
    add_column :events, :is_current_event, :boolean, default: false
  end
end
