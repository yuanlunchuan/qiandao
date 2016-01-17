class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.string :name
      t.string :email
      t.string :company
      t.string :mobile
      t.string :photo

      t.timestamps null: false
    end
  end
end
