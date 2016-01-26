class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string :text
      t.string :help_text
      t.references :survey, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
