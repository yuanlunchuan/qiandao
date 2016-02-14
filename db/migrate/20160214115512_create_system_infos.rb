class CreateSystemInfos < ActiveRecord::Migration
  def change
    create_table :system_infos do |t|
      t.references :event

      t.string :content

      t.boolean :display, default: false
      t.timestamps null: false
    end
  end
end
