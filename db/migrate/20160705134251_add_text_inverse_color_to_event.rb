class AddTextInverseColorToEvent < ActiveRecord::Migration
  def change
    add_column :events, :text_inverse_color, :boolean, default: false
  end
end
