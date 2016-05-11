class AddDefunctToEvents < ActiveRecord::Migration
  def change
  	add_column :events, :defunct, :boolean, default: false
  end
end
