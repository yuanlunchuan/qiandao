class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.references :question
      t.references :admin

      t.text :answer

      t.timestamps null: false
    end
  end
end
