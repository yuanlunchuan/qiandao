class CreateAttendeePraisesQuestions < ActiveRecord::Migration
  def change
    create_table :attendee_praises_questions do |t|
      t.references :attendee
      t.references :question
      t.references :event_question

      t.timestamps null: false
    end
  end
end
