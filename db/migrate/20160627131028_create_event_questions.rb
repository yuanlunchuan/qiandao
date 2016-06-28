class CreateEventQuestions < ActiveRecord::Migration
  def change
    create_table :event_questions do |t|
      t.references :event
      t.string :name
      t.timestamps null: false
    end
  end
end
