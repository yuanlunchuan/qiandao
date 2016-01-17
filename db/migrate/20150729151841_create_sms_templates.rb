class CreateSmsTemplates < ActiveRecord::Migration
  def change
    create_table :sms_templates do |t|
      t.string :sign
      t.string :content
      t.references :event

      t.timestamps null: false
    end
  end
end
