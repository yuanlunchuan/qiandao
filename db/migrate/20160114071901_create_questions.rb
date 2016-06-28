class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string :question_content

      t.references :attendee
      t.references :event
      t.references :event_question

      t.timestamps null: false
    end
  end
end
