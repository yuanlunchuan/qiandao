class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      #活动名称、活动起止日期和时间、活动类型、开放/关闭申请功能键
      t.string :name
      t.references :event
      t.datetime :starts_at
      t.datetime :ends_at
      t.string :location
      t.string :link
      t.text :desc
      t.boolean :apply_enable, default: false

      t.references :event
      t.references :category

      t.timestamps null: false
    end
  end
end
